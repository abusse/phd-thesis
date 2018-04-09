# PhD Thesis - A Dynamic and Component-Based Process Scheduler Framework for Heterogeneous Many-Core Systems

This is the LaTeX source code of my PhD thesis that I wrote until 2016 at
TU Berlin. The topic is _A Dynamic and Component-Based Process Scheduler 
Framework for Heterogeneous Many-Core Systems_. The document can be build with 
[latexmk](https://ctan.org/pkg/latexmk). Howerver, it might be necessary to 
[increase the maximum memory consumption](https://tex.stackexchange.com/questions/7953/how-to-expand-texs-main-memory-size-pgfplots-memory-overload)
of `pdflatex` in order to build the final document. Note that it is not 
possible (yet) to use the `external` library as it will break references into the figures.

In case you want to cite the document, please use the following BibTex entry:

```
@phdthesis{busse2016cobas,
  author = {Anselm Busse},
  title  = {A Dynamic and Component-Based Process Scheduler Framework for Heterogeneous Many-Core System}, 
  school = {Technische Universit\"at Berlin, Germany},
  year   = 2016,
  month  = dec,
  doi    = {10.14279/depositonce-5653}
}
```

---

Since the first decade of the 21st century, improvements in computer performance
are no longer achieved through increasing clock rates but parallelization and
specialization. As a result, heterogeneous many-core systems are becoming more
and more common. Leaving their niche in highly specialized computing, they have
to be supported by a general purpose operating system. A major part of the
support that has to be delivered will be done by the process scheduler as it has
to tailor the task order and placement to those systems. Current approaches to
scheduler architecture are not capable of coping with the resulting challenges.
In particular, the state of the art falls short to provide ways and means to
react to new developments in hardware technology quickly and lacks the
capability to enable the adaptation of the scheduler to the changed environment.
Therefore, the original contribution to the knowledge of this dissertation is a
new approach to the architecture of the operating system's process scheduler.

This dissertation introduces a component-based approach to the process scheduler
architecture that allows the decomposition of the scheduling problem into
distinct parts rather than the monolithic approach as it is state of the art.
Components are connected through Pipes that are an advanced form of runqueues
suitable for the component-based approach. Besides Pipes, information is
distributed among the components through a publish–subscribe-based message
system. Components can change the order of tasks and distribute or merge tasks
from or to several pipes. This allows a flexible scheduler design both during
development and runtime: The developer can reuse existing components and build
new schedulers from existing implementations. Through the explicit layout of the
components code-paths, possible bottlenecks become easier to identify compared
to a monolithic approach. Through the separation, it is also feasible to change
the entire scheduling policy during runtime. This enables an optimal shaping of
the scheduler to the needs of the current working set and the properties of the
underlying hardware architecture.

The components are embedded into a framework that allows a comprehensible
development of schedulers that scale even in many-core systems. The framework
approach permits the integration into several runtime systems without changing
the actual scheduler implementation. This dissertation proves the feasibility
through integrating the framework into major open source kernels: Linux and
FreeBSD. Based on this exemplary implementation, the properties of the approach
are evaluated. The studies show that the component-based scheduler framework is
scalable for hundreds of cores, the overhead is quantified and the benefits of
having well-defined interfaces are demonstrated. Finally, the advantages of a
dynamic adaptation of scheduling strategies at runtime are shown.

