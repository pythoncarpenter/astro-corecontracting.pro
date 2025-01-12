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
        <p style="font-size: 12px; color: #888;">Sent from your website contact form.</p>
      </body>
    </html>
  `;
}

// Astro 2.x supports an async function named `post()` to handle POST requests:
export async function POST({ request }) {
  try {
    // Parse form data from the request
    const formData = await request.formData();
    const name = formData.get('name') || '';
    const email = formData.get('email') || '';
    const phone = formData.get('phone') || '';
    const message = formData.get('message') || '';

    // Create the Nodemailer transporter
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: import.meta.env.EMAIL_USER, // .env -> "EMAIL_USER"
        pass: import.meta.env.EMAIL_PASS, // .env -> "EMAIL_PASS"
      },
    });

    // Prepare the mail data
    const mailOptions = {
      from: import.meta.env.EMAIL_USER,
      to: import.meta.env.EMAIL_USER, // Or your own
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
}
