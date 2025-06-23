import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  console.log('Cron job triggered');
  try {
    const currentTime = new Date().toISOString();
    return new Response(currentTime, { status: 200 });
  } catch (error) {
    return new Response('Error', { status: 500 });
  }
}
