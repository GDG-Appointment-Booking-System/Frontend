const path = require('path');
const jsonServer = require('json-server');

const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const middlewares = jsonServer.defaults();

const TOKEN_PREFIX = 'mock-token-';

const normalizeEmail = (value) => String(value || '').trim().toLowerCase();

const getUserIdFromAuthHeader = (authorization) => {
  if (!authorization || typeof authorization !== 'string') {
    return null;
  }

  const [scheme, token] = authorization.split(' ');
  if (scheme !== 'Bearer' || !token || !token.startsWith(TOKEN_PREFIX)) {
    return null;
  }

  return token.slice(TOKEN_PREFIX.length);
};

server.use(middlewares);
server.use(jsonServer.bodyParser);

server.post('/auth/login', (req, res) => {
  const email = normalizeEmail(req.body?.email);
  const password = String(req.body?.password || '').trim();

  if (!email || !password) {
    return res.status(400).json({
      message: 'Email and password are required.',
    });
  }

  const db = router.db;
  let user = db.get('users').find({ email }).value();

  if (!user) {
    const role = email.includes('admin') ? 'admin' : 'client';
    user = {
      id: `user-${Date.now()}`,
      fullName: role === 'admin' ? 'SharpCut Admin' : 'SharpCut Client',
      email,
      role,
      password,
    };

    db.get('users').push(user).write();
  }

  return res.json({
    accessToken: `${TOKEN_PREFIX}${user.id}`,
    user: {
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
    },
  });
});

server.get('/appointments/me', (req, res) => {
  const userId = getUserIdFromAuthHeader(req.headers.authorization);

  if (!userId) {
    return res.status(401).json({
      message: 'Missing or invalid bearer token.',
    });
  }

  const appointments = router.db.get('appointments').filter({ clientId: userId }).value();
  return res.json(appointments);
});

server.post('/services', (req, _res, next) => {
  if (!req.body.id) {
    req.body.id = `svc-${Date.now()}`;
  }

  next();
});

server.post('/appointments', (req, res, next) => {
  const { serviceId, adminId, startTime } = req.body || {};

  if (!serviceId || !adminId || !startTime) {
    return res.status(400).json({
      message: 'serviceId, adminId, and startTime are required.',
    });
  }

  const db = router.db;
  const service = db.get('services').find({ id: serviceId }).value();

  if (!service) {
    return res.status(400).json({
      message: 'Service not found.',
    });
  }

  const clientIdFromToken = getUserIdFromAuthHeader(req.headers.authorization);
  const clientId = clientIdFromToken || req.body.clientId || 'user-001';
  const parsedStart = new Date(startTime);

  if (Number.isNaN(parsedStart.getTime())) {
    return res.status(400).json({
      message: 'startTime must be a valid ISO timestamp.',
    });
  }

  const end = new Date(parsedStart.getTime() + Number(service.durationMinutes || 45) * 60000);

  req.body = {
    id: `apt-${Date.now()}`,
    serviceId,
    adminId,
    clientId,
    startTime: parsedStart.toISOString(),
    endTime: end.toISOString(),
    status: req.body.status || 'scheduled',
  };

  next();
});

server.use(router);

server.listen(3000, () => {
  // eslint-disable-next-line no-console
  console.log('Mock API running on http://localhost:3000');
});
