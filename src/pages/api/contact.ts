// src/pages/api/contact.ts
import type { APIRoute } from 'astro';
import nodemailer from 'nodemailer';

// Helper to build an HTML message body
function buildHtmlEmail({ name, email, phone, message }) {
  return `
    <html>
      <body style="font-family: Arial, sans-serif; padding: 1rem; color: #333;">
        <h2 style="margin-bottom:16px; color:#444;">New Contact Form Submission</h2>
        <p><strong>Name:</strong> ${name}</p>
        <p><strong>Email:</strong> ${email}</p>
        ${
          phone
            ? `<p><strong>Phone:</strong> ${phone}</p>`
            : ''
        }
        <p><strong>Message:</strong></p>
        <p>${message}</p>
        <hr style="margin-top: 2rem;" />
        <p style="font-size: 12px; color: #888;">Sent from your website www.corecontracting.pro</p>
      </body>
    </html>
  `;
}

export const POST: APIRoute = async ({ request }) => {
  try {
    // Parse form data from the request
    const formData = await request.formData();
    const name = formData.get('name')?.toString();
    const email = formData.get('email')?.toString();
    const phone = formData.get('phone')?.toString();
    const message = formData.get('message')?.toString();

    // Validate required fields (add more validation as needed)
    if (!name || !email || !message) {
      return new Response(JSON.stringify({ success: false, message: 'Name, email, and message are required fields.' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // Create the Nodemailer transporter
    const transporter = nodemailer.createTransport({
      host: import.meta.env.SMTP_HOST,
      port: Number(import.meta.env.SMTP_PORT),
      secure: false, // true for 465, false for other ports
      auth: {
        user: import.meta.env.SMTP_USER,
        pass: import.meta.env.SMTP_PASS,
      },
    });

    // Prepare the mail data
    const mailOptions = {
      from: import.meta.env.SMTP_USER, // Use the SMTP user as sender (your Gmail)
      to: import.meta.env.SMTP_USER,    // Send to yourself
      subject: 'New Contact Form Submission',
      html: buildHtmlEmail({ name, email, phone, message }),
    };

    // Send the email
    await transporter.sendMail(mailOptions);

    // Return success
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });

  } catch (error) {
    console.error('Error sending email:', error);
    return new Response(JSON.stringify({ success: false, message: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};