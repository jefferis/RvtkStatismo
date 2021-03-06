#include <vtkSmartPointer.h>
#include <vtkSphereSource.h>
#include <vtkSmartPointer.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkSimplePointsReader.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkCellArray.h>
#include <vtkCellData.h>
#include <vtkRenderer.h>
#include <vtkProperty.h>
#include <RcppEigen.h>
#include <string.h>
#include <vtkPolyData.h>
#include <vtkTriangle.h>
#include <vtkXMLPolyDataReader.h>
#include <vtkUnstructuredGrid.h>
#include <vtkGenericDataObjectReader.h>
using namespace Rcpp;

RcppExport SEXP vtkRead(SEXP filename_, SEXP legacy_)
{
  CharacterVector filename(filename_);
  bool legacy = as<bool>(legacy_);
  vtkSmartPointer<vtkPolyData> polydata = vtkSmartPointer<vtkPolyData>::New();
  if (legacy) {
    vtkSmartPointer<vtkGenericDataObjectReader> reader = vtkSmartPointer<vtkGenericDataObjectReader>::New();
    reader->SetFileName(filename[0]);
    reader->Update();
    if(reader->IsFilePolyData())   
      polydata = reader->GetPolyDataOutput();
    else 
      return wrap(1);
	 
  } else {
    vtkSmartPointer<vtkXMLPolyDataReader> reader = vtkSmartPointer<vtkXMLPolyDataReader>::New();
    if (reader->CanReadFile(filename[0])) {
	reader->SetFileName(filename[0]);
	reader->Update();
	if(reader->GetOutput() != NULL)
	  polydata = reader->GetOutput();
	else 
	  return wrap(1);
      } else  
	  return wrap(1);
      }
 
    
  vtkSmartPointer<vtkPoints> points = vtkSmartPointer<vtkPoints>::New();
  //polydata = reader->GetOutput();
  
  int np = polydata->GetNumberOfPoints();
  points=polydata->GetPoints();
  NumericMatrix vb(3,np);
  double point[3];
  for (int i=0; i< np;i++) {
    polydata->GetPoints()->GetPoint(i,point);
    for (int j=0; j<3; j++)
      vb(j,i) = point[j];
  }
  
  int h;
  vtkIdType npts=3,*pts; 
  int nit = polydata->GetNumberOfPolys();
  IntegerMatrix it(3,nit);
  vtkSmartPointer<vtkCellArray> oCellArr= vtkSmartPointer<vtkCellArray>::New();
  oCellArr=polydata->GetPolys();
  for (int i=0; i< nit;i++) {
    h = oCellArr->GetNextCell(npts,pts); 
    if(h == 0){
      break;
    } 
    if(npts == 3){
      it(0,i) = pts[0];
      it(1,i) = pts[1];
      it(2,i) = pts[2]; 
    }
  }
  
    return  List::create(Named("vb")=vb,
			 Named("it")=it
			 );
} 

 
