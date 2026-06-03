import * as bcrypt from 'bcryptjs';

async function generateBcrypt() {
  const password = process.argv[2] || 'password123';

  const salt = await bcrypt.genSalt(10);
  const hash = await bcrypt.hash(password, salt);

  console.log(`Password: ${password}`);
  console.log(`Hash: ${hash}`);
}

generateBcrypt().catch(console.error);
