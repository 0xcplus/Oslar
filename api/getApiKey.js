export default function handler(req, res) {
  const apiKey = process.env.YOUR_API_KEY; // 환경 변수에서 API 키 가져오기
  res.status(200).json({ apiKey });
}