import type { Plugin } from "@opencode-ai/plugin";

export const PushoverNotifications: Plugin = async ({ directory }) => {
	const apiKey = process.env.PUSHOVER_API_KEY;
	const userKey = process.env.PUSHOVER_USER_KEY;

	if (!apiKey || !userKey) {
		return {
			event: async ({ event }) => {
				if (event.type === "session.idle") {
					await Bun.write(Bun.stdout, "\x07");
				}
			},
		};
	}

	const projectName = directory.split("/").pop();

	const sendNotification = async (message: string): Promise<void> => {
		try {
			await fetch("https://api.pushover.net/1/messages.json", {
				method: "POST",
				headers: {
					"Content-Type": "application/x-www-form-urlencoded",
				},
				body: new URLSearchParams({
					token: apiKey,
					user: userKey,
					title: `opencode ${projectName}`,
					message: message,
				}),
			});
		} catch (error) {
			console.error("Failed to send Pushover notification:", error);
		}
	};

	return {
		event: async ({ event }): Promise<void> => {
			if (event.type === "session.idle") {
				await sendNotification("Session idle");
			}
		},
	};
};
