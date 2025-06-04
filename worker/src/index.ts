/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Bind resources to your worker in `wrangler.jsonc`. After adding bindings, a type definition for the
 * `Env` object can be regenerated with `npm run cf-typegen`.
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

interface Env {
	REPO_BUCKET: R2Bucket;
}

export default {
	async fetch(request, env): Promise<Response> {
		if (request.method !== "GET") {
			return new Response("Method Not Allowed", { status: 405 });
		}
		const objectNameEncoded = request.url.split("/").pop() ?? "";
		const objectName = decodeURIComponent(objectNameEncoded);

		if (!objectName) {
			return new Response("Status: Healthy");
		}

		const object = await env.REPO_BUCKET.get(objectName);
		if (!object) {
			return new Response("Object not found", { status: 404 });
		}
		const header = new Headers();
		object.writeHttpMetadata(header);
		header.set("etag", object.httpEtag);
		header.set("Content-Type", "application/octet-stream");

		return new Response(object.body, {
			headers: header,
			status: 200,
		});
	},
} satisfies ExportedHandler<Env>;
