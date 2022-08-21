#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { program } = require('commander');
const toml = require('toml');

program
	.argument('<toml path>', 'path of TOML file')
  // .option('-k, --key [string...]', 'set what key you want to echo');
  .option('-k, --key <string>', 'set what key you want to echo');

program.parse();

const options = program.opts();

const file_path = process.argv.slice(2)[0];
if(!file_path || !valid_toml_file_path(file_path)){
	console.error(`[ERROR] Wrong argument. First parameter should be toml file path.`);
	process.exit(1);
}
if(!options.key){
	console.error(`[ERROR] Invalid or empty flag --key [-k].`);
	process.exit(1);
}

const content = fs.readFileSync(file_path);

let data = toml.parse(content.toString());
let splitted_option = options.key.split('.');

while(splitted_option.length > 0){
	const k = splitted_option[0];
	if(typeof data[k] === 'undefined'){
		console.error(`[ERROR] Invalid key for this toml file.`);
		process.exit(1);
	}
	splitted_option = splitted_option.slice(1);
	data = data[k];
}

console.log(data);

function valid_toml_file_path(file_path){
	if(!fs.existsSync(file_path)){
		return false;
	}
	const ext = path.extname(file_path);
	if(ext !== '.toml'){
		return false;
	}
	return true;
}

