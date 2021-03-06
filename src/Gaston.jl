## Copyright (c) 2013 Miguel Bazdresch
##
## This file is distributed under the 2-clause BSD License.

__precompile__(true)
module Gaston

export closefigure, closeall, figure,
       plot, plot!, scatter, scatter!, stem, bar, histogram, imagesc,
       surf, surf!, contour, scatter3, scatter3!,
       printfigure, set

import Base.show, Base.isempty

using Random
using DelimitedFiles

const VERSION = v"0.11"

## Handle Unix/Windows differences
#
# Define gnuplot's end-of-plot delimiter. It is different in Windows
# than in Unix, thanks to different end-of-line conventions.
gmarker_start = "GastonBegin\n"
gmarker_done = "GastonDone\n"
if Sys.iswindows()
    gmarker_start = "GastonBegin\r\n"
    gmarker_done = "GastonDone\r\n"
end

# load files
include("gaston_types.jl")
include("gaston_aux.jl")
include("gaston_config.jl")
include("gaston_figures.jl")
include("gaston_llplot.jl")
include("gaston_2d.jl")
include("gaston_3d.jl")
include("gaston_histograms.jl")
include("gaston_images.jl")
include("gaston_print.jl")

# define function to determine if function is empty
Base.isempty(f::Figure) = (f.curves == nothing)

# initialize internal state
gnuplot_state = GnuplotState()

mutable struct Pipes
    gstdin :: Pipe
    gstdout :: Pipe
    gstderr :: Pipe
    Pipes() = new()
end

const P = Pipes()

# initialize gnuplot
function __init__()
    global P
    try
        success(`gnuplot --version`)
    catch
        error("Gaston cannot be loaded: gnuplot is not available on this system.")
    end
    gstdin = Pipe()
    gstdout = Pipe()
    gstderr = Pipe()
    gproc = run(pipeline(`gnuplot`,
                         stdin = gstdin, stdout = gstdout, stderr = gstderr),
                wait = false)
    process_running(gproc) || error("There was a problem starting up gnuplot.")
    close(gstdout.in)
    close(gstderr.in)
    close(gstdin.out)
    P.gstdin = gstdin
    P.gstdout = gstdout
    P.gstderr = gstderr

    global IsJupyterOrJuno = false
    if isdefined(Main, :IJulia) && Main.IJulia.inited
        global IsJupyterOrJuno = true
    elseif isdefined(Main, :Juno) && Main.Juno.isactive()
        global IsJupyterOrJuno = true
    end

    global config = default_config()

    return nothing
end

end
