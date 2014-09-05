# Swift Floating Point Experiments

I got caught out when trying to compare two arrays of Double values for equality. A bit of internet research led to http://floating-point-gui.de/errors/comparison/ which has 
- a nice rundown of what the problems are
- an example implementation of a nearlyEqual function
- a set of tests for verifying the nearlyEqual function
- a list of resources to investigate further.

This project is an implementation of nearlyEqual for Float and Double in Swift as well as an implementation of the tests from floating-point-gui.de (for Floats only at this stage).

The project doesn't do anything if you run it. Run the tests instead. There are two tests. The first runs through all the tests from floating-point-gui.de using Swifts standard == operator for the Float type (quite a few of these don't pass). The second runs through the implementation of nearlyEqual using the same tests.

## TODO
Create a test set for the Double datatype