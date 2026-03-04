import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";

export async function httpTrigger1(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    context.log(`Http function processed request for url "${request.url}"`);

    const name = request.query.get('name') || await request.text() || 'world';

    // curl -s ifconfig.me と同等の処理
    let outboundIp = 'Unknown';
    try {
        const response = await fetch('https://ifconfig.me/ip');
        outboundIp = (await response.text()).trim();
    } catch (error) {
        context.error('Failed to fetch outbound IP:', error);
        outboundIp = 'Error: Could not retrieve';
    }

    return {
        body: `Hello, ${name}!\n\nOutbound IP: ${outboundIp}`
    };
};

app.http('httpTrigger1', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: httpTrigger1
});
