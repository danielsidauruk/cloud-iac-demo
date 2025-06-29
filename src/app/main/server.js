require('dotenv').config();

const express = require('express');
const { Pool } = require('pg');
const { createClient } = require('redis');
const amqp = require('amqplib');
const { S3Client, ListObjectsCommand, PutObjectCommand } = require('@aws-sdk/client-s3');
const fileUpload = require('express-fileupload');

const app = express();
const PORT = process.env.PORT || 3000;

const pgPool = new Pool({
    user: process.env.PGUSER,
    host: process.env.PGHOST,
    database: process.env.PGDATABASE,
    password: process.env.PGPASSWORD,
    port: parseInt(process.env.PGPORT || '5432', 10),
    ssl: process.env.PGSSLMODE === 'require' ? { rejectUnauthorized: false } : false,
});

const redisClient = createClient({
    url: `redis://${process.env.REDIS_SERVER}:${process.env.REDIS_PORT || 6379}`,
    password: process.env.REDIS_PASSWORD,
});

redisClient.on('error', err => console.error('Redis Client Error', err));

const RABBITMQ_URL = process.env.RABBITMQ_SERVER;
const RABBITMQ_EXCHANGE = process.env.RABBITMQ_EXCHANGE || 'my_integration_exchange';
const RABBITMQ_ROUTING_KEY = process.env.RABBITMQ_ROUTING_KEY || 'integration.test';

const RABBITMQ_SERVER_HOST = process.env.RABBITMQ_SERVER.trim();
const RABBITMQ_USERNAME_ENV = process.env.RABBITMQ_USERNAME.trim();
const RABBITMQ_PASSWORD_ENV = process.env.RABBITMQ_PASSWORD.trim();

const ENCODED_RABBITMQ_USERNAME = encodeURIComponent(RABBITMQ_USERNAME_ENV);
const ENCODED_RABBITMQ_PASSWORD = encodeURIComponent(RABBITMQ_PASSWORD_ENV);

const RABBITMQ_URL_WITH_CREDS = `amqps://${ENCODED_RABBITMQ_USERNAME}:${ENCODED_RABBITMQ_PASSWORD}@${RABBITMQ_SERVER_HOST.replace('amqps://', '')}`;

const S3_BUCKET_NAME = process.env.AWS_BUCKET_NAME;
const S3_REGION = process.env.AWS_REGION;
const s3Client = new S3Client({ region: S3_REGION });

app.use(express.json());

app.use(fileUpload());

app.use(express.static('public'));

app.get('/api/db-test', async (req, res) => {
    try {
        const client = await pgPool.connect();
        const result = await client.query('SELECT NOW() AS current_time');
        client.release();
        res.json({
            service: 'PostgreSQL/RDS',
            query: 'SELECT NOW() AS current_time',
            status: 'Connected',
            data: result.rows[0],
        });
    } catch (error) {
        console.error('PostgreSQL error:', error.message);
        res.status(500).json({ service: 'PostgreSQL/RDS', status: 'Error', message: error.message });
    }
});

app.get('/api/redis-test', async (req, res) => {
    try {
        if (!redisClient.isReady) {
            await redisClient.connect();
            console.log('Redis client reconnected');
        }
        await redisClient.set('integration:test_key', 'Hello from Redis App!');
        const value = await redisClient.get('integration:test_key');
        res.json({
            service: 'Redis/ElastiCache',
            status: 'Connected & Data Set/Get',
            data: value,
        });
    } catch (error) {
        console.error('Redis error:', error.message);
        res.status(500).json({
            service: 'Redis/ElastiCache',
            status: 'Error',
            message: error.message,
        });
    }
});

app.get('/api/mq-test', async (req, res) => {
    let connection;
    try {
        connection = await amqp.connect(RABBITMQ_URL_WITH_CREDS);
        const channel = await connection.createChannel();
        await channel.assertExchange(RABBITMQ_EXCHANGE, 'topic', { durable: true });
        const message = `Test message from integration app at ${new Date().toISOString()}`;
        channel.publish(RABBITMQ_EXCHANGE, RABBITMQ_ROUTING_KEY, Buffer.from(message));

        await channel.close();
        await connection.close();
        res.json({
            service: 'RabbitMQ/Amazon MQ',
            status: 'Message Published',
            message: message,
        });
    } catch (error) {
        console.error('RabbitMQ error:', error.message);
        res.status(500).json({ service: 'RabbitMQ/Amazon MQ', status: 'Error', message: error.message });
    }
});

app.post('/api/mq-publish-text', async (req, res) => {
    const messageText = req.body.message;

    if (!messageText) {
        return res.status(400).json({ service: 'RabbitMQ/Amazon MQ', status: 'Error', message: 'Message text is required.' });
    }

    let connection;
    try {
        connection = await amqp.connect(RABBITMQ_URL_WITH_CREDS);
        const channel = await connection.createChannel();
        await channel.assertExchange(RABBITMQ_EXCHANGE, 'topic', { durable: true });
        channel.publish(RABBITMQ_EXCHANGE, RABBITMQ_ROUTING_KEY, Buffer.from(messageText));

        await channel.close();
        await connection.close();
        res.json({ service: 'RabbitMQ/Amazon MQ', status: 'Custom Message Published', message: messageText });
    } catch (error) {
        console.error('RabbitMQ Custom Publish error:', error.message);
        res.status(500).json({ service: 'RabbitMQ/Amazon MQ', status: 'Error', message: error.message || 'Failed to publish custom message.' });
    }
});

app.get('/api/s3-test', async (req, res) => {
    try {
        const command = new ListObjectsCommand({ Bucket: S3_BUCKET_NAME });
        const data = await s3Client.send(command);
        const objectNames = data.Contents ? data.Contents.map(obj => obj.Key) : [];
        res.json({
            service: 'S3',
            status: 'Bucket Listed',
            bucket: S3_BUCKET_NAME,
            objects: objectNames,
        });
    } catch (error) {
        console.error('S3 error:', error.message);
        res.status(500).json({ service: 'S3', status: 'Error', message: error.message });
    }
});

app.post('/api/s3-upload', async (req, res) => {
    if (!req.files || Object.keys(req.files).length === 0) {
        return res.status(400).json({ service: 'S3', status: 'Error', message: 'No files were uploaded.' });
    }

    const uploadedFile = req.files.myFile;
    const fileName = `${Date.now()}_${uploadedFile.name}`;
    const params = {
        Bucket: S3_BUCKET_NAME,
        Key: fileName,
        Body: uploadedFile.data,
        ContentType: uploadedFile.mimetype,
    };

    try {
        const command = new PutObjectCommand(params);
        await s3Client.send(command);
        res.json({
            service: 'S3',
            status: 'File Uploaded',
            fileName: fileName,
            size: uploadedFile.size,
        });
    } catch (error) {
        console.error('S3 Upload error:', error.message);
        res.status(500).json({ service: 'S3', status: 'Error', message: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`Simple Integration App listening on port ${PORT}`);
    console.log(`Access at http://localhost:${PORT} (for local docker) or your Ingress URL`);

    redisClient.connect().catch(err => console.error('Initial Redis connection failed:', err.message));
});

// Testing to trigger Github Workflows #2
