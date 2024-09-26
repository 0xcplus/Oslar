export default function handler(req, res) {
  const apiKey = process.env.YOUR_API_KEY; // 환경 변수에서 API 키 가져오기

  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  res.status(200).json({ apiKey });
}