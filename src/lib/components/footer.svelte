<script>
	import {
		GithubIcon,
		InstagramIcon,
		LinkedinIcon,
		MailIcon,
		YoutubeIcon
	} from 'svelte-feather-icons';

	const socialLinks = [
		{
			name: 'gmail',
			href: 'mailto:germaniiifelisarta@gmail.com'
		},
		{
			name: 'github',
			href: 'https://github.com/germaniii'
		},
		{
			name: 'instagram',
			href: 'https://instagram.com/germaniiifelisarta'
		},
		{
			name: 'linkedin',
			href: 'https://www.linkedin.com/in/german-iii-felisarta-648b9420b'
		},
		{
			name: 'youtube',
			href: 'https://www.youtube.com/channel/UCLdx8-LN-JAnrExazmhjmDA'
		}
	];
</script>

<footer>
	{#each socialLinks as { href, name } (name)}
		<a {href} target="_blank" class="social-icon">
			{#if name === 'gmail'}
				<MailIcon strokeWidth="1px" size="20" />
			{:else if name === 'github'}
				<GithubIcon strokeWidth="1px" size="20" />
			{:else if name === 'instagram'}
				<InstagramIcon strokeWidth="1px" size="20" />
			{:else if name === 'linkedin'}
				<LinkedinIcon strokeWidth="1px" size="20" />
			{:else if name === 'youtube'}
				<YoutubeIcon strokeWidth="1px" size="20" />
			{:else}
				<span></span>
			{/if}
		</a>
	{/each}
</footer>

<style>
	footer {
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 0 1em;
		gap: 1em;
	}

	a {
		color: red;
		text-align: center;
	}

	.social-icon {
		color: black;
	}
</style>
