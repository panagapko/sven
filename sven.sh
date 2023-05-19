#!/bin/zsh

# New Sveltekit project with TailwindCSS
# Created by: Chris Panagapko - github.com/panagapko

# Function to display usage
function usage() {
    echo "sven - a quickstart script for SvelteKit + Tailwind CSS"
    echo "Usage: sven [-t] [-r] project_name"
    echo "Options:"
    echo "-t  Configure Tailwind CSS"
    echo "-r  Open VScode and npm run dev"
    echo "project_name: A name for your project"
    exit 1
}

# Parse command line options.
while getopts tr opt; do
    case "$opt" in
        t) TAILWIND=true ;;
        r) RUNDEV=true ;;
        *) usage ;;
    esac
done

# Remove the switches we parsed above from the arguments list
shift $(expr $OPTIND - 1)

# Check if name is provided
if [ "$#" -eq 0 ]; then
    echo "Error: You need to specify a project name!"
    usage
fi

# Assign name
NAME=$1

# Check if zsh or bash because I like colors

if [ "$SHELL" = "/bin/zsh" ]; then
    print " "
    print "############################"
    print -P "# %F{202}SvelteKit %F{default}+ %F{blue}Tailwind CSS %F{default}#"
    print -P "# %F{200}sven%F{default} - a quickstart tool #"
    print -P "%F{default}############################"
    print " "
else
    echo " "
    echo "Sven - a quickstart script for SvelteKit + Tailwind CSS"
    echo " "
fi



# Make sure npm is installed
if ! [ -x "$(command -v npm)" ]; then
    echo 'Error: npm is not installed' >&2
    exit 1
else 
  echo "found npm version `npm -v`"
fi

# Default behavior
echo "\033[0;33mInitializing SvelteKit project: `pwd`/$NAME"
npm create svelte@latest $NAME
echo " "
echo "\033[0;32mRunning post install scripts..."
cd $NAME
echo "SvelteKit Installation" > ./sven.log
echo "---" >> ./sven.log
npm install >> ./sven.log
echo " " >> ./sven.log
echo " "
echo "\033[1;33mSvelteKit initialization complete"
echo " "

# If -t is specified, configure Tailwind CSS
if [ "$TAILWIND" = true ]; then
    echo "\033[0;36mConfiguring Tailwind CSS"
    echo "Tailwind CSS Configuration" >> ./sven.log
    echo "---" >> ./sven.log
    npm i -D tailwindcss postcss autoprefixer >> ./sven.log
    npx tailwindcss init -p >> ./sven.log
    echo "\033[0m...Created postcss.config.js"
    echo "\033[0m...Created tailwind.config.js"
    sed -in "s|content:\ \[\],|content: \['./src/\*\*/\*\.{html,js,svelte,ts}'\],|g" tailwind.config.js
    echo "Configured Tailwind CSS for SvelteKit: tailwind.config.js" >> ./sven.log
    echo $'@tailwind base;\n@tailwind components;\n@tailwind utilities;' > ./src/app.css
    echo "\033[0m...Created /src/app.css"
    echo $'<script>\nimport "../app.css";\n</script>\n\n<slot />' > ./src/routes/+layout.svelte
    echo "\033[0m...Created default +layout.svelte"
    echo $'<h1 class="text-3xl font-bold"><span class="text-orange-600">SvelteKit</span><span class="mx-1">+</span><span class="text-sky-500">Tailwind CSS</span><br><span class="ml-1 text-xl font-light">installed with</span><span class="text-fuchsia-700 mx-1 text-xl font-light">sven</span></h1>' > ./src/routes/+page.svelte
    echo "\033[0m...Patched +page.svelte"
    echo "\033[1;36mTailwind CSS configuration complete"
    echo " "
fi

# If -r is specified, launch and run dev
if [ "$RUNDEV" = true ]; then
    echo " "
    echo "\033[32mLaunching $NAME ..."
    echo "\033[0m "
    code .
    npm run dev -- --open
fi