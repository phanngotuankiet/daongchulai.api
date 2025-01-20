import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS
  app.enableCors({
    origin: '*', // In production, replace with your frontend URL
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type, Accept, Authorization',
  });

  // Sử dụng PORT từ environment hoặc 4000
  const port = process.env.PORT || 4000;
  await app.listen(port);
  console.log(`Application is running on: ${await app.getUrl()}`);
}

bootstrap();

// Error handling
process.on('uncaughtException', (error, origin) => {
  console.log('----- Uncaught exception -----');
  console.log(error);
  console.log('----- Exception origin -----');
  console.log(origin);
});

process.on('unhandledRejection', (reason, promise) => {
  console.log('----- Unhandled Rejection at -----');
  console.log(promise);
  console.log('----- Reason -----');
  console.log(reason);
});
