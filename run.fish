#!/usr/bin/fish

# script that builds and runs the project.
# I should really use cmake though

function check_environment
    printf "-> Checking build environment\n"

    clang++ --version &> /dev/null; or {
        printf "-> $(set_color bryellow -r)clang++$(set_color normal) not found\n"
        exit 1
    }
end

function dc_build
    printf "-> Preparing build\n"

    rm -rf build/
    mkdir build; or return 1

    # a cache directory for the project to use as a temporary storage
    mkdir -p .cache/

    printf "-> Building project\n"

    set source_files ./**.cpp ./**.cc
    clang++ -std=c++20 $source_files -o build/bin; or return 1
end

function run_binary
    printf "-> Executing $(set_color blue)build/bin$(set_color --reset)\n"
    build/bin
    printf "--> Process exited with exit code $status\n"
end

# check environment
check_environment
if test $status -ne 0
    printf "--> $(set_color red -r)Build failed\n"
    exit 1
end

# execute build
dc_build
if test $status -ne 0
    printf "--> $(set_color red -r)Build failed\n"
    exit 2
end

printf "\n--> $(set_color brgreen -r)Build complete$(set_color --reset)\n"

time run_binary
exit 0
