import type { Plugin } from "@opencode-al/plugin";

export const Notify: Plugin = async ({ $ }) => {
	return {
		async event(input) {
			if (input.event.type == "session.idle") {
				await $`say "Your code is done!"`;
			}
		},
	};
};
