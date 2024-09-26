const express = require('express');
const cors = require('cors');
const crypto = require('crypto');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const port = 3000;

// CORS 설정
app.use(cors());

// 기본 경로에 대한 GET 요청 처리
app.get('/', (req, res) => {
  res.send('Welcome to the API!');
});

// API 키 복호화 함수
const decryptApiKey = (encryptedApiKey, passphrase) => {
  const iv = Buffer.from(encryptedApiKey.iv, 'hex'); // IV
  const key = crypto.scryptSync(passphrase, 'salt', 32); // 키 생성
  const encryptedText = Buffer.from(encryptedApiKey.content, 'hex'); // 암호화된 키

  const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
  let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  
  return decrypted;
};

// API 엔드포인트
app.get('/api/get-api-key', (req, res) => {
  const encryptedApiKey = {
    iv: process.env.ENCRYPTED_API_KEY_IV, // 암호화된 키의 IV
    content: process.env.ENCRYPTED_API_KEY, // 암호화된 키
  };
  const passphrase = process.env.SECRET_PASSPHRASE; // 패스프레이즈

  const apiKey = decryptApiKey(encryptedApiKey, passphrase);
  res.json({ apiKey });
});

// 서버 시작
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});