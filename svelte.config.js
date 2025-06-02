import adapter from '@sveltejs/adapter-node';

const config = { kit: { adapter: adapter({
	out: 'build',
	precompress: true,
	envPrefix: ''
}) 
} };

export default config;
