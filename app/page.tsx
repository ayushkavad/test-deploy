import Image from 'next/image';

export default function Home() {
  return (
    <div className="grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20 font-[family-name:var(--font-geist-sans)]">
      {process.env.NEXT_PUBLIC_APP_URL === 'development' && (
        <div>
          <h1>We are in Development</h1>
        </div>
      )}
      {process.env.NEXT_PUBLIC_APP_URL === 'production' && (
        <div>
          <h1 className="text-zinc-500">We are in Production</h1>
        </div>
      )}
    </div>
  );
}
