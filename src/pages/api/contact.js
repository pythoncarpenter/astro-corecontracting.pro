export async function post({ request }) {
    try {
      // Parse the form data
      const formData = await request.formData();
      const name = formData.get('name');
      const email = formData.get('email');
      const message = formData.get('message');
  
      // Debugging: Log the data to confirm receipt
      console.log('Contact Form Submission:');
      console.log(`Name: ${name}`);
      console.log(`Email: ${email}`);
      console.log(`Message: ${message}`);
  
      // TODO: Add functionality to send the data to an email server or save it in a database
  
      // Respond to the frontend with a success message
      return new Response(JSON.stringify({ success: true, message: 'Form submitted successfully!' }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    } catch (error) {
      console.error('Error handling contact form submission:', error);
  
      // Respond to the frontend with an error message
      return new Response(JSON.stringify({ success: false, error: 'Failed to submit the form' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      });
    }
  }