using System.Reflection;
using System.Runtime.InteropServices;
using RoboSharp;

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("RoboSharp")]
[assembly: AssemblyDescription("C# wrapper for RoboCopy (" + BuildDetails.GitCommit + ")")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("")]
[assembly: AssemblyProduct("RoboSharp")]
[assembly: AssemblyCopyright("Copyright ©  2014")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible 
// to COM components.  If you need to access a type in this assembly from 
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("ec4fd7c1-fa3c-4ebe-8ba8-a063bb6eae87")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version 
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Build and Revision Numbers 
// by using the '*' as shown below:
// [assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyVersion(BuildDetails.GitMajor + "." +
                           BuildDetails.GitMinor + "." +
                           BuildDetails.GitPatch + "." +
                           BuildDetails.GitTagDist)]
[assembly: AssemblyFileVersion(BuildDetails.GitMajor + "." +
                               BuildDetails.GitMinor + "." +
                               BuildDetails.GitPatch + "." +
                               BuildDetails.GitTagDist)]

[assembly: AssemblyInformationalVersion(BuildDetails.BuildDate +
                                        " " + BuildDetails.GitCommit +
                                        " (" + BuildDetails.GitBranch + ")")]
