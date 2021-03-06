#include "vec_operator.h"

#define TOLERR 1e-6
#define DEBUG 0
/*
 * Details:
 *   Find the location of the nodes which cell is inside.
 * Usages:
 *   cell_ind = find_loc_cell(x, y, locVertList, xp, yp);
 *				
 */

void mexFunction(int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{

	/* check input & output */
	if (nrhs != 5)
		mexErrMsgTxt("Wrong number of input arguments.");
	if (nlhs != 1)
		mexErrMsgTxt("Wrong number of output arguments");

	/* get inputs */
	double *x = mxGetPr(prhs[0]);
	double *y = mxGetPr(prhs[1]);
	double *locVertList = mxGetPr(prhs[2]);
	double *xp = mxGetPr(prhs[3]);
	double *yp = mxGetPr(prhs[4]);

	size_t Np, K;
	Np = mxGetM(prhs[0]);
	K = mxGetN(prhs[0]);

	size_t Nvert;
	Nvert = mxGetM(prhs[2]) * mxGetN(prhs[2]);

	size_t Mp; // No. of unknown points
	Mp = mxGetM(prhs[3]) * mxGetN(prhs[3]);

	/* allocation of output */
	plhs[0] = mxCreateDoubleMatrix((mwSize)1, (mwSize)Mp, mxREAL);
	double *cell_ind = mxGetPr(plhs[0]);

	if (Nvert < 2)
		mexErrMsgTxt("Number of vertex is less than 2.");

	int i, m, k;
	for (m = 0; m < Mp; m++)
	{
		POINT p;
		p.x = xp[m];
		p.y = yp[m];
		double f;
		for (k = 0; k < K; k++)
		{
			f = 1;

			POINT A, B, C;
			POINT AB, AC, AP;

			for (i = 0; i < Nvert; i++)
			{
				int v = (int)locVertList[i] - 1;
				int v1 = (int)locVertList[(i - 1 + Nvert) % Nvert] - 1;
				int v2 = (int)locVertList[(i + 1) % Nvert] - 1;

				A.x = x[v + k * Np];
				A.y = y[v + k * Np];
				B.x = x[v1 + k * Np];
				B.y = y[v1 + k * Np];
				C.x = x[v2 + k * Np];
				C.y = y[v2 + k * Np];

				minus(B, A, &AB);
				minus(C, A, &AC);
				minus(p, A, &AP);

				f *= cross(AB, AP) * cross(AB, AC);

				// if ((k == 468) & (m == 263))
				// {
				// 	// mexPrintf("k=%d, Np=%d, v=%d, v1=%d, v2=%d\n", k, Np, v, v1, v2);
				// 	mexPrintf("M=%d, k=%d, Nv=%d, A=[%f,%f], B=[%f,%f], "
				// 			  "C = [ %f, %f ], "
				// 			  "P = [ %f, %f ], f=%e\n ",
				// 			  m, k, i, A.x, A.y, B.x, B.y, C.x, C.y, p.x, p.y, f);
				// }
				if (f <= 0)
					break; // p is on edge or outside
			}

			if (f > 0)
			{ // p is inside
				cell_ind[m] = k + 1;
				break;
			}

			if (f < 0)
			{
				continue;
			}

			if (f < TOLERR)
			{ // f=0, p is on line AB
				double temp = dot(AB, AP);
#if DEBUG
				mexPrintf("dot AB AP = %f\n", temp);
#endif
				if ((temp >= 0.0) & (temp <= dot(AB, AB)))
				{ // p is on edge AB
					cell_ind[m] = k + 1;
					break;
				}
			}
#if DEBUG
			mexPrintf("Mp=%d, k=%d, f=%f\n", m, k, f);
#endif
		}

		if (fabs(cell_ind[m]) < TOLERR)
		{
			mexPrintf("#%d Point is out of region\n", m + 1);
			// return;
		}
	}

	return;
}