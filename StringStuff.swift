//
//  StringStuff.swift
//
//  Created by Van
//  Created on 2024-04-11
//  Version 1.0
//  Copyright (c) 2024 Van Nguyen. All rights reserved.
//
//  Finds the max run of the strings in the input file

import Foundation

// Function to read input from a file
func readInputFromFile(filePath: String) -> String? {
	do {
		// Attempt to read the contents of the file at the given file path
		let inputString = try String(contentsOfFile: filePath)
		return inputString // Return the contents of the file as a string
	} catch {
		// If an error occurs during file reading, print an error message and return nil
		print("Error reading input file: \(error)")
		return nil
	}
}

// Function to write output to a file
func writeOutputToFile(outputFilePath: String, output: String) {
	// Open an output stream to the specified file path
	guard let outputStream = OutputStream(toFileAtPath: outputFilePath, append: false) else {
		// If unable to open the output stream, print an error message and return
		print("Failed to open output file.")
		return
	}
	// Open the output stream
	outputStream.open()

	//https://www.hackingwithswift.com/new-syntax-swift-2-defer
	defer {
		// Close the output stream when the function exits
		outputStream.close()
	}

	// Convert the output string to an array of UTF-8 bytes
	let buffer = Array(output.utf8)

	// Write the buffer to the output stream
	let bytesWritten = outputStream.write(buffer, maxLength: buffer.count)
	if bytesWritten < 0 {
		// If an error occurs during writing, print an error message
		print("Error writing to output file.")
	}
}

// Function to find the maximum run of consecutive characters in a string
func findMaxRun(_ input: String) -> (Int, [Character]) {
	// Counter for the current run of consecutive characters
	var currentRun = 1

	// Maximum run of consecutive characters found
	var highestRun = 1

	// Characters forming the maximum run
	var maxRunCharacters = [Character]()

	// Convert the input string to an array of characters
	let characters = Array(input)
	for index in 0..<characters.count - 1 {
		if characters[index] == characters[index + 1] {
			// If the current character is the same as the next one, increment the current run
			currentRun += 1
			if currentRun > highestRun {
				// If the current run is higher than the highest run found so far,
				// update the highest run and reset the list of characters forming the maximum run
				highestRun = currentRun
				maxRunCharacters.removeAll()
				maxRunCharacters.append(characters[index])
			} else if currentRun == highestRun {
				// If the current run equals the highest run, add the character to the list
				maxRunCharacters.append(characters[index])
			}
		} else {
			// If the current character is different from the next one, reset the current run counter
			currentRun = 1
		}
	}

	// Return the highest run and the list of characters forming the maximum run
	return (highestRun, maxRunCharacters)
}

// File paths
let inputFilePath = "./input.txt" // Path to the input file
let outputFilePath = "./output.txt" // Path to the output file

// Read input file
guard let inputString = readInputFromFile(filePath: inputFilePath) else {
	// If unable to read the input file, print an error message and exit
	fatalError("Unable to read input file.")
}

//https://developer.apple.com/documentation/foundation/nsstring/1413214-components
// Split the input string into lines
let lines = inputString.components(separatedBy: .newlines)

var output = "" // Initialize the output string
for line in lines {
	// Skip processing if the line is blank
	if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
		continue
	}
	// For each non-blank line in the input file, find the maximum run of consecutive characters
	let (maxRun, maxRunCharacters) = findMaxRun(line)
	// Append the result to the output string
	output += "The max run is \(maxRun) for character(s): \(maxRunCharacters)\n"

	print("The max run is \(maxRun) for character(s): \(maxRunCharacters)")
}

// Write output to file
writeOutputToFile(outputFilePath: outputFilePath, output: output)
