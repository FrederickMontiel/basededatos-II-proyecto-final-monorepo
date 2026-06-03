const isLocalhost = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
const apiUrl = isLocalhost ? 'http://localhost:3000/api' : 'http://backend:3000/api';

export const environment = {
  production: false,
  apiUrl: apiUrl,
};
