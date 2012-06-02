refacto
=======

refacto was created in response to a stack overflow question here:  
http://stackoverflow.com/questions/10708321/rails-code-refactoring-tool-for-mac/10861183#10861183

I decided it would be fun to make this little tool with a few extra quirks.

refacto was born.  I haven't created an installer or
anything so you will have to have X-Code to compile this into a program.  

Here's your readme:
  
Proper Usage is: refacto findString changeString <file extensions> <options>
	
File extensions are not optional.  In order for any files to be renamed 
or refactored, you must list at least one file extension.

Options:
	-a  : Ask for confirmation to refactor or rename a file.
  -nf : Do not rename folders or subfolders
  -ci : Case Insenitive.  Will change all versions of findString