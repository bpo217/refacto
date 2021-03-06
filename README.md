refacto
=======

refacto was created in response to a stack overflow question here:  <br />
http://stackoverflow.com/questions/10708321/rails-code-refactoring-tool-for-mac/10861183#10861183
<br /><br />
I decided it would be fun to make this little tool with a few extra quirks.
<br /><br />
In a nutshell: refacto without any options renames all subfolders of
the current working directory, renames all files in the directory and all sub
directories, AND finds all instances of the findString INSIDE those files if
they are openable and renames them.  There is no difference whether it's a ruby
class, a c++ class, or anything else.  As long as the contents can be opened
in text format, they will be changed.  
<br /><br />
No installer exists yet.<br />
If it wasn't obvious, YOU MUST ENABLE GARBAGE COLLECTION WHEN YOU COMPILE THIS.
<br /><br />
Here's your readme:
<br /><br />  
Proper Usage is: <br />

    refacto findString changeString <file extensions> <options>
	
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
	
Example: <br />

    refacto -h

<br />OR<br />

    refacto -help

<br /><br />

Examples:<br />

    refacto ruby rails erb rb -a

<br /><br />
- Will touch all folders and subfolders of current directory<br />
- Will change all instances of ruby to rails (case sensitive)<br />
- Will touch on all files with .erb and .rb as the last extension<br />
- Will ask for your approval before each refactor or rename<br />
<br />

    refacto ruby rails erb rb -rf -ci

<br/>
<br />
- Will NOT touch all folders and subfolders of current directory<br />
- Will change all instances of ruby to rails (case INSENSITIVE)<br />
- Will touch on all files with .erb and .rb as the last extension<br />
- Will NOT ask for your approval before each refactor or rename<br />