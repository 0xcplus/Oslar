const express = require('express');
const cors = require('cors');
require('dotenv').config(); // .env 파일에서 환경 변수 불러오기

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors()); // CORS 허용

app.get('/api/getApiKey', (req, res) => {
  const apiKey = process.env.OPEN_AI_API_KEY; // 환경 변수에서 API 키 읽기
  if (apiKey) {
    res.json({ apiKey });
  } else {
    res.status(404).json({ error: 'API key not found' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});


/*export default function handler(req, res) {
  const apiKey = process.env.OPEN_AI_API_KEY;

  // CORS 헤더 추가
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (apiKey) {
    res.status(200).json({ apiKey });
  } else {
    print('Error fetching API key: ${response.statusCode} - ${response.body}');
    return null;
  }
}*/