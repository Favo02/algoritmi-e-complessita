---
applyTo: "**.typ"
---

# GitHub Copilot Instructions for Algoritmi e Complessità

## Project Context
This repository contains academic notes and materials for the "Algoritmi e Complessità" (Algorithms and Complexity) course, written in Typst format.

## Review Focus Areas

### 1. Typst Syntax
- You are not up to date with the Typst compiler, so if you find anything weird or uncommon, triple check before suggesting an edit
- The project uses specific external packages that are already imported: `gentle-clues`, `equate`, `codly`, `fletcher`, `cetz`, and `cetz-venn`
- Do NOT suggest importing NEW Typst external packages beyond those already in use
- It is guaranteed that the code compiles into a valid PDF document

### 2. Template Consistency
- Ensure consistent use of custom helper functions: `nota`, `attenzione`, `informalmente`, `dimostrazione`, `teorema`, and `esempio`
- Check proper application of the document template and styling
- Check proper use of inline math `$...$` and display math `$ ... $`
- Ensure consistent use of colored math helpers: `mg` (olive), `mm` (maroon), `mo` (orange), `mr` (red), `mp` (purple), `mb` (blue)
- Verify proper use of diagram creation tools (`fletcher`, `cetz`, `cetz-venn`) for visual elements
- Check consistent formatting of definition lists using `/` notation
- Check that TODO comments are properly formatted and tracked

### 3. Content Clarity
- Italian Language: Check for proper Italian grammar and academic writing style
- Explanations: Ensure complex concepts are explained clearly and progressively
- Examples: Verify that examples effectively illustrate the concepts
- Mathematical Accuracy: Verify mathematical formulas, algorithms, and proofs for correctness
- Algorithmic Descriptions: Check that algorithm descriptions are clear, complete, and accurate
- Complexity Analysis: Ensure Big O, Omega, and Theta notations are used correctly
- Terminology: Verify proper use of computer science and algorithmic terminology in Italian

### 4. Code Examples and Pseudocode
- Review algorithm implementations for correctness
- Check that code examples follow good programming practices
- Verify syntax highlighting and code formatting using codly
- Ensure code examples match the theoretical explanations

## Specific Review Guidelines

### For Pull Requests:
1. Focus on content accuracy over minor formatting issues
2. Prioritize mathematical and algorithmic correctness
3. Suggest improvements for clarity and educational value
4. Check for consistency with existing content style
5. Do not suggest importing new Typst packages or features
6. Pay attention to TODO comments and incomplete sections marked by the `appunti` separator

### Content Review Priorities:
1. **Mathematical Accuracy**: Verify all formulas, proofs, and complexity analysis
2. **Educational Flow**: Ensure concepts build logically and examples support theory
3. **Italian Grammar**: Check for proper academic Italian language usage
4. **Template Consistency**: Verify proper use of all custom helper functions and styling
5. **Visual Elements**: Check that diagrams and mathematical formatting enhance understanding

### Common Patterns to Watch:
- Proper use of `$` for inline math and `$ ... $` for display math
- Consistent use of colored math helpers: `mg()`, `mm()`, `mo()`, `mr()`, `mp()`, `mb()`
- Correct application of info boxes: `nota()`, `attenzione()`, `informalmente()`, `esempio()`, `dimostrazione()`, `teorema()`
- Proper Italian academic terminology for computer science concepts
- Consistent use of definition lists with `/` separator for terminology sections
- Proper formatting of algorithms and pseudocode using `codly`
- Appropriate use of diagram tools (`fletcher`, `cetz`, `cetz-venn`) for visual representations

## Interaction Style
- Suggest improvements for complex errors
- Simply point out minor issues (like typos) without extensive explanations
- Consider the academic context and Italian language requirements
- When reviewing TODO sections, provide constructive guidance on completion
- Respect the established template structure and don't suggest major architectural changes
