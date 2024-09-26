export default function handler(req, res) {
  const apiKey = process.env.YOUR_API_KEY; // 환경 변수에서 API 키 가져오기

  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*'); // 모든 출처 허용
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS'); // 허용할 HTTP 메서드
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type'); // 허용할 헤더

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end(); // OPTIONS 요청에 대한 응답
    return;
  }

  // GET 요청 처리
  res.status(200).json({ apiKey });
}
