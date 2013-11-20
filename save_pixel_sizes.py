from java.io import File
from loci.formats import ImageReader
from loci.formats import MetadataTools

import glob

# Create output file
outFile = open('./pixel_sizes.txt','w')

# Get list of DM3 files
filenames = glob.glob('*.dm3')

for filename in filenames:

	# Open file
	file = File('.', filename)

	# parse file header
	imageReader = ImageReader()
	meta = MetadataTools.createOMEXMLMetadata()
	imageReader.setMetadataStore(meta)
	imageReader.setId(file.getAbsolutePath())
	
	# get pixel size
	pSizeX = meta.getPixelsPhysicalSizeX(0)
	
	# close the image reader
	imageReader.close()

	outFile.write(filename + "\t" + str(pSizeX) + "\n")

# Close the output file
outFile.close()
