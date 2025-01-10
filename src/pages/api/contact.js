import 'dotenv/config';
import nodemailer from 'nodemailer';

// Handle GET requests to avoid warnings
export async function GET() {
  return new Response(
    JSON.stringify({ success: false, message: 'GET requests are not allowed on this route.' }),
    {
      status: 405, // Method Not Allowed
      headers: { 'Content-Type': 'application/json' },
    }
  );
}

// Handle POST requests for contact form submissions
export async function POST({ request }) {
  try {
    const formData = await request.formData();
    const name = formData.get('name');
    const email = formData.get('email');
    const message = formData.get('message');

    if (!name || !email || !message) {
      return new Response(
        JSON.stringify({ success: false, error: 'All fields are required.' }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        }
      );
    }

    const transporter = nodemailer.createTransport({
      host: 'smtp.gmail.com',
      port: 587,
      secure: false,
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    const mailOptions = {
      from: `"Core Contact Form" <${process.env.EMAIL_USER}>`,
      to: 'mitch.mcquoid@gmail.com',
      subject: 'New Contact Form Submission',
      text: `Name: ${name}\nEmail: ${email}\nMessage: ${message}`,
      html: `<p><strong>Name:</strong> ${name}</p>
             <p><strong>Email:</strong> ${email}</p>
             <p><strong>Message:</strong> ${message}</p>`,
    };

    await transporter.sendMail(mailOptions);

    return new Response(
      JSON.stringify({ success: true, message: 'Your message has been sent successfully.' }),
      {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  } catch (error) {
    console.error('Error sending email:', error.message);

    return new Response(
      JSON.stringify({ success: false, error: 'Failed to send email. Please try again later.' }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
}