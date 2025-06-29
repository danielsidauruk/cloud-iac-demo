require('dotenv').config();

const amqp = require('amqplib');

const RABBITMQ_SERVER_HOST = (process.env.RABBITMQ_SERVER || '').trim();
const RABBITMQ_USERNAME_ENV = (process.env.RABBITMQ_USERNAME || '').trim();
const RABBITMQ_PASSWORD_ENV = (process.env.RABBITMQ_PASSWORD || '').trim();

const ENCODED_RABBITMQ_USERNAME = encodeURIComponent(RABBITMQ_USERNAME_ENV);
const ENCODED_RABBITMQ_PASSWORD = encodeURIComponent(RABBITMQ_PASSWORD_ENV);

const RABBITMQ_URL_WITH_CREDS = `amqps://${ENCODED_RABBITMQ_USERNAME}:${ENCODED_RABBITMQ_PASSWORD}@${RABBITMQ_SERVER_HOST.replace('amqps://', '')}`;

const RABBITMQ_EXCHANGE = process.env.RABBITMQ_EXCHANGE || 'my_integration_exchange';
const RABBITMQ_ROUTING_KEY_PATTERN = process.env.RABBITMQ_ROUTING_KEY_PATTERN || 'integration.test';

async function startRabbitMQConsumer() {
  let connection;
  try {
    console.log(`🔗 Attempting to connect to RabbitMQ at: ${RABBITMQ_URL_WITH_CREDS.split('@')[1]}`);
    connection = await amqp.connect(RABBITMQ_URL_WITH_CREDS);
    console.log('✅ Connected to RabbitMQ!');

    const channel = await connection.createChannel();
    console.log('🛠️ Channel created.');

    await channel.assertExchange(RABBITMQ_EXCHANGE, 'topic', { durable: true });
    console.log(`💬 Exchange '${RABBITMQ_EXCHANGE}' asserted.`);

    const QUEUE_NAME = 'my_terminal_consumer_queue';
    const q = await channel.assertQueue(QUEUE_NAME, { durable: true, exclusive: false, autoDelete: false });
    console.log(`📦 Using queue '${q.queue}'.`);

    await channel.bindQueue(q.queue, RABBITMQ_EXCHANGE, RABBITMQ_ROUTING_KEY_PATTERN);
    console.log(`🤝 Queue '${q.queue}' bound to exchange '${RABBITMQ_EXCHANGE}' with routing key '${RABBITMQ_ROUTING_KEY_PATTERN}'.`);

    console.log(`⏳ Waiting for messages in queue '${q.queue}'. To stop, terminate the process (e.g., Ctrl+C).`);

    channel.consume(q.queue, (msg) => {
      if (msg.content) {
        const messageContent = msg.content.toString();
        const timestamp = new Date().toISOString();

        console.log(`\n✨ RECEIVED MESSAGE:`);
        console.log(`  • Content: "${messageContent}"`);
        console.log(`  • Timestamp: ${timestamp}`);

        channel.ack(msg);
      } else {
        console.log("❌ Consumer cancelled by server (no content)");
      }
    }, {
      noAck: false
    });

    process.on('SIGINT', async () => {
      console.log('🛑 SIGINT received. Shutting down consumer...');
      if (connection) {
        await connection.close();
      }
      process.exit(0);
    });

    process.on('SIGTERM', async () => {
      console.log('🛑 SIGTERM received. Shutting down consumer...');
      if (connection) {
        await connection.close();
      }
      process.exit(0);
    });

  } catch (error) {
    console.error('🚨 RabbitMQ Consumer Error:', error);
    if (connection) {
      try {
        await connection.close();
        console.log('🚫 RabbitMQ connection closed due to error. Attempting reconnect.');
      } catch (e) {
        console.error('💥 Error closing connection:', e.message);
      }
    }
    console.log('🔄 Retrying RabbitMQ connection in 5 seconds...');
    setTimeout(startRabbitMQConsumer, 5000);
  }
}

startRabbitMQConsumer();

// Testing to trigger Github Workflows #3