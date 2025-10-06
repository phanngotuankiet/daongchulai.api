const express = require('express');
const AWS = require('aws-sdk');
const { v4: uuidv4 } = require('uuid');

const router = express.Router();

// S3 Configuration
AWS.config.update({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_REGION || 'ap-southeast-2'
});

const s3 = new AWS.S3();
const BUCKET_NAME = process.env.AWS_S3_BUCKET_NAME || 'daong';

// Generate presigned URL for upload
const generateUploadUrl = async (fileName, fileType) => {
  const key = `posts/${uuidv4()}-${fileName}`;
  
  const params = {
    Bucket: BUCKET_NAME,
    Key: key,
    ContentType: fileType,
    Expires: 3600
  };

  const signedUrl = s3.getSignedUrl('putObject', params);
  
  return {
    uploadUrl: signedUrl,
    fileUrl: `https://${BUCKET_NAME}.s3.${process.env.AWS_REGION || 'ap-southeast-2'}.amazonaws.com/${key}`,
    key: key
  };
};

// Delete file from S3
const deleteFile = async (key) => {
  const params = {
    Bucket: BUCKET_NAME,
    Key: key,
  };

  await s3.deleteObject(params).promise();
};

// Extract S3 key from URL
const extractS3Key = (url) => {
  const match = url.match(/https:\/\/[^\/]+\.s3\.[^\/]+\.amazonaws\.com\/(.+)/);
  return match ? match[1] : null;
};

// Generate presigned URL for image upload
router.post('/generate-upload-url', async (req, res) => {
  try {
    console.log('Upload request received:', req.body);
    const { fileName, fileType } = req.body;

    if (!fileName || !fileType) {
      return res.status(400).json({
        message: 'Missing fileName or fileType'
      });
    }

    // Validate file type
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    if (!allowedTypes.includes(fileType)) {
      return res.status(400).json({
        message: 'Invalid file type. Only images are allowed.'
      });
    }

    const { uploadUrl, fileUrl, key } = await generateUploadUrl(fileName, fileType);
    console.log('Generated upload URL for:', fileName);

    res.json({
      uploadUrl,
      fileUrl,
      key
    });

  } catch (error) {
    console.error('Error generating upload URL:', error);
    res.status(500).json({
      message: 'Internal server error'
    });
  }
});

// Delete image from S3
router.delete('/delete-image', async (req, res) => {
  try {
    const { imageUrl } = req.body;

    if (!imageUrl) {
      return res.status(400).json({
        message: 'Missing imageUrl'
      });
    }

    const key = extractS3Key(imageUrl);
    if (!key) {
      return res.status(400).json({
        message: 'Invalid S3 URL'
      });
    }

    await deleteFile(key);

    res.json({
      message: 'Image deleted successfully'
    });

  } catch (error) {
    console.error('Error deleting image:', error);
    res.status(500).json({
      message: 'Internal server error'
    });
  }
});

module.exports = router;
