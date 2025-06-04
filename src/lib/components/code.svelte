<script>
	import { ClipboardIcon } from "svelte-feather-icons";

	let { children } = $props()

	const onclick = async () => {
		const text = document.getElementById('code-text').textContent;
		await navigator.clipboard.writeText(text)
	}
</script>

<div class="code-block">
	<p id="code-text">{@render children()}</p>
	<button class="clipboard-icon" {onclick}>
		<ClipboardIcon size="20"/>
	</button>
</div>

<style>
.code-block {
	position: relative;
}
.clipboard-icon {
	position: absolute;
	right: 2.5em;
	top: 1em;
	cursor: pointer;
	border: 1px solid var(--blue-dim);
	padding: 5px;
	border-radius: 3px;
	color: var(--green-dim);
	background-color: #00000000;

	&:hover {
		border: 1px solid var(--blue);
		color: var(--green);
	}
}
p {
	position: relative;
	font-family: 'Fira Code';
	color: var(--blue);
	border-radius: 5px;
	border: 1px solid var(--blue-dim);
	white-space: pre-wrap;
	padding: 1em;
	margin: 1em;
	font-size: 0.8em;
}
</style>


