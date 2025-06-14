document.addEventListener('DOMContentLoaded', () => {
    const resultsDiv = document.getElementById('results');
    const mqMessageInput = document.getElementById('mqMessageInput');
    const s3FileInput = document.getElementById('s3FileInput');
    const s3UploadStatusDiv = document.getElementById('s3UploadStatus');
    const s3FileNameDisplay = document.getElementById('s3FileNameDisplay');

    if (s3FileInput && s3FileNameDisplay) {
        s3FileInput.addEventListener('change', () => {
            if (s3FileInput.files.length > 0) {
                s3FileNameDisplay.textContent = s3FileInput.files[0].name;
            } else {
                s3FileNameDisplay.textContent = 'No file chosen';
            }
        });
    }

    async function fetchApi(endpoint) {
        resultsDiv.textContent = `Testing ${endpoint}...`;
        resultsDiv.className = '';
        try {
            const response = await fetch(endpoint);
            const data = await response.json();
            if (response.ok) {
                resultsDiv.textContent = JSON.stringify(data, null, 2);
                resultsDiv.className = 'success';
            } else {
                resultsDiv.textContent = `Error: ${JSON.stringify(data, null, 2)}`;
                resultsDiv.className = 'error';
            }
        } catch (error) {
            resultsDiv.textContent = `Network Error: ${error.message}`;
            resultsDiv.className = 'error';
        }
    }

    async function publishCustomMqMessage() {
        const messageText = mqMessageInput.value.trim();
        if (!messageText) {
            resultsDiv.textContent = 'Please enter a message to publish.';
            resultsDiv.className = 'error';
            return;
        }

        resultsDiv.textContent = `Publishing custom message: "${messageText}"...`;
        resultsDiv.className = '';

        try {
            const response = await fetch('/api/mq-publish-text', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ message: messageText }),
            });
            const data = await response.json();
            if (response.ok) {
                resultsDiv.textContent = `Success: ${JSON.stringify(data, null, 2)}`;
                resultsDiv.className = 'success';
            } else {
                resultsDiv.textContent = `Error: ${JSON.stringify(data, null, 2)}`;
                resultsDiv.className = 'error';
                console.log(`Error: ${JSON.stringify(data, null, 2)}`);
            }
        } catch (error) {
            resultsDiv.textContent = `Network Error during custom MQ publish: ${error.message}`;
            resultsDiv.className = 'error';
            console.error('Network Error during custom MQ publish:', error);
        }
    }

    async function uploadS3File() {
        const file = s3FileInput.files[0];
        if (!file) {
            s3UploadStatusDiv.textContent = 'Please select a file to upload.';
            s3UploadStatusDiv.className = 'error';
            return;
        }

        s3UploadStatusDiv.textContent = `Uploading "${file.name}"...`;
        s3UploadStatusDiv.className = '';

        const formData = new FormData();
        formData.append('myFile', file);

        try {
            const response = await fetch('/api/s3-upload', {
                method: 'POST',
                body: formData,
            });
            const data = await response.json();
            if (response.ok) {
                s3UploadStatusDiv.textContent = `Upload Success: ${JSON.stringify(data, null, 2)}`;
                s3UploadStatusDiv.className = 'success';
            } else {
                s3UploadStatusDiv.textContent = `Upload Error: ${JSON.stringify(data, null, 2)}`;
                s3UploadStatusDiv.className = 'error';
                console.error('S3 Upload Error:', data);
            }
        } catch (error) {
            s3UploadStatusDiv.textContent = `Network Error during S3 upload: ${error.message}`;
            s3UploadStatusDiv.className = 'error';
            console.error('Network Error during S3 upload:', error);
        }
    }

    const dbTestButton = document.getElementById('dbTest');
    if (dbTestButton) {
        dbTestButton.addEventListener('click', () => fetchApi('/api/db-test'));
    }

    const redisTestButton = document.getElementById('redisTest');
    if (redisTestButton) {
        redisTestButton.addEventListener('click', () => fetchApi('/api/redis-test'));
    }

    const mqPublishCustomButtonRef = document.getElementById('mqPublishCustom');
    if (mqPublishCustomButtonRef) {
        mqPublishCustomButtonRef.addEventListener('click', publishCustomMqMessage);
    }

    const s3UploadButtonRef = document.getElementById('s3UploadButton');
    if (s3UploadButtonRef) {
        s3UploadButtonRef.addEventListener('click', uploadS3File);
    }

    const s3TestButtonRef = document.getElementById('s3Test');
    if (s3TestButtonRef) {
        s3TestButtonRef.addEventListener('click', () => fetchApi('/api/s3-test'));
    }
});
