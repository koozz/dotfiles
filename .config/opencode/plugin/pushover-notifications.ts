import type { Plugin } from "@opencode-ai/plugin";
import type { Event } from "@opencode-ai/sdk";

export const PushoverNotifications: Plugin = async ({
	directory,
	worktree,
}) => {
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

	// Get the last significant part of the directory versus the worktree
	const projectName = directory.split("/").pop();
	const worktreeName = worktree ? worktree.split("/").pop() : null;
	const displayName =
		worktreeName && worktreeName !== projectName
			? `${projectName} (${worktreeName})`
			: projectName;

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
					title: `opencode ${displayName}`,
					message: message,
					ttl: "1800",
				}),
			});
		} catch (error) {
			console.error("Failed to send Pushover notification:", error);
		}
	};

	return {
		event: async ({ event }): Promise<void> => {
			if (event.type === "session.idle") {
				await sendNotification("Session is idle.");
			} else if (event.type === "session.error") {
				await sendNotification(
					`${event.properties.error?.name || "Unknown error"}: ${event.properties.error?.message || "No message"}`,
				);
			}
		},
	};
};
