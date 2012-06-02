refacto
=======

refacto was created in response to a stack overflow question here:  <br />
http://stackoverflow.com/questions/10708321/rails-code-refactoring-tool-for-mac/10861183#10861183
<br /><br />
I decided it would be fun to make this little tool with a few extra quirks.
<br /><br />
refacto was born.  I haven't created an installer or
anything so you will have to have X-Code to compile this into a program.  
<br /><br />
Here's your readme:
<br /><br />  
Proper Usage is: refacto findString changeString "file extensions" "options"
<br /><br />
File extensions are not optional.  In order for any files to be renamed 
or refactored, you must list at least one file extension.

Options:<br />
	-a  : Ask for confirmation to refactor or rename a file.<br />
  -nf : Do not rename folders or subfolders<br />
  -ci : Case Insenitive.  Will change all versions of findString<br />
<br /><br />
Stand-Alone Options:<br />
	-h|-help : Basically print this tutorial<br />
	
	Example: refacto -h OR refacto -help 
	<br /><br />

Examples:<br />
<br />
refacto ruby rails erb rb -a <br/>
<br />
- Will touch all folders and subfolders of current directory<br />
- Will change all instances of ruby to rails (case sensitive)<br />
- Will touch on all files with .erb and .rb as the last extension<br />
- Will ask for your approval before each refactor or rename<br />

refacto ruby rails erb rb -rf -ci <br/>
<br />
- Will NOT touch all folders and subfolders of current directory<br />
- Will change all instances of ruby to rails (case INSENSITIVE)<br />
- Will touch on all files with .erb and .rb as the last extension<br />
- Will NOT ask for your approval before each refactor or rename<br />