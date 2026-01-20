export const metadata = {
  title: 'Notes API',
  description: 'Workshop demo for AWS ECS deployment',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
