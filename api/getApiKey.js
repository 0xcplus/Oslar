// api/getApiKey.js
export default function handler(req, res) {
  const apiKey = process.env.OPEN_AI_API_KEY; // 환경변수에서 API 키 가져오기

  if (apiKey) {
    res.status(200).json({ apiKey }); // API 키 반환
  } else {
    res.status(404).json({ error: 'API key not found' });
  }
}