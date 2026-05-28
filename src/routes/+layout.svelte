<script>
	import Footer from '$lib/components/footer.svelte';
	import Header from '$lib/components/header.svelte';
	import Sidebar from '$lib/components/sidebar.svelte';

	let { children } = $props();
	let collapsed = $state(true);
</script>

<svelte:head>
	<title>Devtools | German III</title>
</svelte:head>

<main class="layout">
	<Header />

	<div class="layout-container">
		<Sidebar collapsed={collapsed} ontoggle={() => collapsed = !collapsed} />
		<div class="page-content">
			{@render children()}
		</div>
	</div>

	<Footer />
</main>

<style>
	.layout {
		height: 100vh;
		display: grid;
		grid-template-rows: auto 1fr auto;
	}

	.layout-container {
		display: flex;
		flex-direction: row;
		background: var(--background);
		height: 100%;
		min-height: 0;
	}

	.page-content {
		flex-grow: 1;
		overflow-y: auto;
		background: var(--background);
		color: var(--text);
		margin: 1em;
		width: 100%;
		min-width: 0;
	}

	@media (max-width: 768px) {
		.sidebar {
			position: fixed;
			top: 0;
			left: 0;
			height: 100vh;
			z-index: 1000;
		}

		.sidebar:not(.collapsed) {
			width: var(--sidebar-width);
			box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
		}

		.page-content {
			margin: 0.5em;
			width: 100%;
		}
	}
</style>
