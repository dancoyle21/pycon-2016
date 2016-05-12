FROM jupyter/minimal-notebook

#include the necessary files in the image at the default working path set by the Jupyter team
ADD shapefiles/ /home/jovyan/work/shapefiles/
ADD images/ /home/jovyan/work/images/
ADD *.p *.py *ipynb /home/jovyan/work/

#custom conda installation of dependencies for tutorial
#conda install of scipy master branch so that scipy.spatial.SphericalVoronoi may be used during tutorial
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 \
	'ipykernel' \
	'numpy=1.11.0' \ 
	'matplotlib=1.5.1' \
	'ipywidgets=5.1*' \
	'openblas' \
	&& /bin/bash -c "source activate /opt/conda/envs/python2 && conda install -c https://conda.anaconda.org/treddy scipy && conda clean -tipsy && pip install triangle pyshp && jupyter nbextension enable --py widgetsnbextension --sys-prefix"

USER root
RUN bin/bash -c "source activate /opt/conda/envs/python2/ && jupyter nbextension enable --py --sys-prefix widgetsnbextension"
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install
RUN bin/bash -c "source activate /opt/conda/envs/python2/ && jupyter nbextension enable --py --sys-prefix widgetsnbextension"
USER jovyan
RUN bin/bash -c "source activate /opt/conda/envs/python2/ && jupyter nbextension enable --py --sys-prefix widgetsnbextension"
