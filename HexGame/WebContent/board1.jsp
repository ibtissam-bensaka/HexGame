<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<title>Board</title>
<link rel="stylesheet" href="css/board.css">
<link rel="icon" href="./images/icone.ico" />
<script type="text/javascript">
var i, j, k, fini=true,debut, Commencer, taille=11, lancer=false, Action="";
var nbMov, MaxnbMov, MaxFld=taille*taille, permuter, ActiveColor=0,IsAI=0;
joueur = new Array(2);
Niveau = new Array(2);  
ImgNum = new Array(taille);
for (i=0; i<taille; i++)
  ImgNum[i] = new Array(taille);
Fld = new Array(taille);
for (i=0; i<taille; i++)
  Fld[i] = new Array(taille);
Pot = new Array(taille);
for (i=0; i<taille; i++)
  Pot[i] = new Array(taille); 
for (i=0; i<taille; i++)
{ for (j=0; j<taille; j++)
    Pot[i][j] = new Array(4); 
}
Bridge = new Array(taille);
for (i=0; i<taille; i++)
  Bridge[i] = new Array(taille); 
for (i=0; i<taille; i++)
{ for (j=0; j<taille; j++)
    Bridge[i][j] = new Array(4); 
}
Upd = new Array(taille);
for (i=0; i<taille; i++)
  Upd[i] = new Array(taille); 
History = new Array(MaxFld+1);
for (i=0; i<MaxFld+1; i++)
  History[i] = new Array(2);
Pic= new Array(3);
//charger les images
Pic[0] = new Image();
Pic[0].src = "./images/hex_r.gif";
Pic[1] = new Image();
Pic[1].src = "./images/hex_t.gif";
Pic[2] = new Image();
Pic[2].src = "./images/hex_b.gif";

debut=true;
joueur[0]=true;
joueur[1]=false;
Niveau[0]=2;
Niveau[1]=3;
//*****************************************une fonction qui permet d'initialiser le jeu
function initialiser()
{ if (lancer) { Action="initialiser()"; return; }  
  var ii, jj;
  for (ii=0; ii<taille; ii++)
  { for (jj=0; jj<taille; jj++)
      Fld[ii][jj]=0;
  }
  if (debut) Commencer=true;
  else Commencer=false;
  nbMov=0;
  MaxnbMov=0;
  reactiverBoard();
  poserPion(true);
  fini=false;    
}
//**********************************************une fonction qui permet de modifier les options du jeu
function SetOption(nn, mm)
{ if (lancer) { Action="SetOption("+nn+","+mm+")"; return; }  
  if (nn<2) 
  { if (mm==0)
      joueur[nn]=true; //le joueur
    else
      joueur[nn]=false;//machine
  }
  else debut=mm; 
}
//************************************************une fonction qui permet de modifier le niveau du jeu 
function SetNiveau(nn, mm)
{ if (lancer) { Action="SetNiveau("+nn+","+mm+")"; return; }  
  Niveau[nn]=mm;
}

function minuteur()
{ if (Action!="")
  { eval(Action);
    Action="";
    return;
  }
  if (fini) return;
  if (lancer) return;
  if (joueur[(nbMov+Commencer+1)%2]) { poserPion(true); return; }
  lancer=true;
  var ll=Niveau[(nbMov+Commencer+1)%2];
  recupererPion(ll);  
  setTimeout("MinMaxAlphaBeta("+eval(((nbMov+1+Commencer)%2)*2-1)+","+ll+")",10);
}
//*********une fonction permet de faire un déplacement
function deplacer(ii, jj, oo)
{ var ccol, kk, iis=ii, jjs=jj;
  if (nbMov==1)
  { if (Fld[ii][jj]!=0)
    { Fld[ii][jj]=0;
      reactiverImages(ii, jj);
      iis=jj; 
      jjs=ii;
      permuter=1;
    } 
    else permuter=0; 
  }
  ccol=((nbMov+1+Commencer)%2)*2-1;
  Fld[iis][jjs]=ccol;
  reactiverImages(iis, jjs);
  if (History[nbMov][0]!=ii)
  { History[nbMov][0]=ii;
    MaxnbMov=nbMov+1;
  }
  if (History[nbMov][1]!=jj)
  { History[nbMov][1]=jj;
    MaxnbMov=nbMov+1;
  }  
  nbMov++;
  if (MaxnbMov<nbMov)
    MaxnbMov=nbMov;
  if (! oo) return; 
  recupererPion(0);
  poserPion(true);
  if (ccol<0)
  { if ((Pot[ii][jj][2]>0)||(Pot[ii][jj][3]>0)) return;
    alert("Perfect! You win!");
    document.getElementById('next').style.display='inline';
    Blink(0);
  }
  else
  { if ((Pot[ii][jj][0]>0)||(Pot[ii][jj][1]>0)) return;
  	alert("Try again! You can do it!");
    Blink(0);
  }
  fini=true;
}
//une fonction qui retourne une valeur aléatoire entre 0 et nn-1
function random(nn)
{ return(Math.floor(Math.random()*1000)%nn);
}
function poserPion(bb)
{ 
  if (!IsAI) return;
  if (bb) recupererPion(2);
}

function signe(xx)
{ if (xx<0) return(-1);
  if (xx>0) return(1);
  return(0);
}  
//cette fonction permet au machine de faire le meilleur déplacement  
function MinMaxAlphaBeta(theCol, leNiveau)
{ var ii, jj, kk, ii_b, jj_b, ff=0, ii_q=0, jj_q=0, cc, pp0, pp1;
  vv=new Array();
  if (nbMov>0) ff=190/(nbMov*nbMov);
  mm=20000;
  for (ii=0; ii<taille; ii++)
  { for (jj=0; jj<taille; jj++)
    { if (Fld[ii][jj]!=0)
      { ii_q+=2*ii+1-taille;
        jj_q+=2*jj+1-taille;
      }
    }
  }
  ii_q=signe(ii_q);
  jj_q=signe(jj_q);
  for (ii=0; ii<taille; ii++)
  { for (jj=0; jj<taille; jj++)
    { if (Fld[ii][jj]==0)
      { mmp=Math.random()*(49-leNiveau*16);
        mmp+=(Math.abs(ii-5)+Math.abs(jj-5))*ff;
        mmp+=8*(ii_q*(ii-5)+jj_q*(jj-5))/(nbMov+1);
        if (leNiveau>2)
        { for (kk=0; kk<4; kk++)
            mmp-=Bridge[ii][jj][kk];
        }
        pp0=Pot[ii][jj][0]+Pot[ii][jj][1];
        pp1=Pot[ii][jj][2]+Pot[ii][jj][3];
        mmp+=pp0+pp1;
        if ((pp0<=268)||(pp1<=268)) mmp-=400; //140+128
        vv[ii*taille+jj]=mmp;          
        if (mmp<mm)
        { mm=mmp; 
          ii_b=ii;
          jj_b=jj;
        }  
      }  
    }
  }
  if (leNiveau>2)
  { mm+=108;
    for (ii=0; ii<taille; ii++)
    { for (jj=0; jj<taille; jj++)
      { if (vv[ii*taille+jj]<mm)
        { if (theCol<0)//red
          { if ((ii>3)&&(ii<taille-1)&&(jj>0)&&(jj<3)) 
            { if (Fld[ii-1][jj+2]==-theCol)
              { cc=testerBordures(ii-1,jj+2,-theCol);
                if (cc<2) 
                { ii_b=ii; 
                  if (cc<-1) { ii_b--; cc++; }
                  jj_b=jj-cc; 
                  mm=vv[ii*taille+jj]; 
                }
              }
            }
            if ((ii>0)&&(ii<taille-1)&&(jj==0))
            { if ((Fld[ii-1][jj+2]==-theCol)&&
                  (Fld[ii-1][jj]==0)&&(Fld[ii-1][jj+1]==0)&&(Fld[ii][jj+1]==0)&&(Fld[ii+1][jj]==0))
                { ii_b=ii; jj_b=jj; mm=vv[ii*taille+jj]; }  
            }
            if ((ii>0)&&(ii<taille-4)&&(jj<taille-1)&&(jj>taille-4)) 
            { if (Fld[ii+1][jj-2]==-theCol)
              { cc=testerBordures(ii+1,jj-2,-theCol); 
                if (cc<2) 
                { ii_b=ii; 
                  if (cc<-1) { ii_b++; cc++; }
                  jj_b=jj+cc; 
                  mm=vv[ii*taille+jj]; 
                }
              }  
            }
            if ((ii>0)&&(ii<taille-1)&&(jj==taille-1))
            { if ((Fld[ii+1][jj-2]==-theCol)&&
                  (Fld[ii+1][jj]==0)&&(Fld[ii+1][jj-1]==0)&&(Fld[ii][jj-1]==0)&&(Fld[ii-1][jj]==0))
                { ii_b=ii; jj_b=jj; mm=vv[ii*taille+jj]; }  
            }
          }
          else
          { if ((jj>3)&&(jj<taille-1)&&(ii>0)&&(ii<3)) 
            { if (Fld[ii+2][jj-1]==-theCol)
              { cc=testerBordures(ii+2,jj-1,-theCol); 
                if (cc<2) 
                { jj_b=jj; 
                  if (cc<-1) { jj_b--; cc++; }
                  ii_b=ii-cc; 
                  mm=vv[ii*taille+jj]; 
                }
              }  
            }
            if ((jj>0)&&(jj<taille-1)&&(ii==0))
            { if ((Fld[ii+2][jj-1]==-theCol)&&
                  (Fld[ii][jj-1]==0)&&(Fld[ii+1][jj-1]==0)&&(Fld[ii+1][jj]==0)&&(Fld[ii][jj+1]==0))
                { ii_b=ii; jj_b=jj; mm=vv[ii*taille+jj]; }  
            }
            if ((jj>0)&&(jj<taille-4)&&(ii<taille-1)&&(ii>taille-4)) 
            { if (Fld[ii-2][jj+1]==-theCol)
              { cc=testerBordures(ii-2,jj+1,-theCol);
                if (cc<2) 
                { jj_b=jj; 
                  if (cc<-1) { jj_b++; cc++; }
                  ii_b=ii+cc; 
                  mm=vv[ii*taille+jj]; 
                }
              }  
            }
            if ((jj>0)&&(jj<taille-1)&&(ii==taille-1))
            { if ((Fld[ii-2][jj+1]==-theCol)&&
                  (Fld[ii][jj+1]==0)&&(Fld[ii-1][jj+1]==0)&&(Fld[ii-1][jj]==0)&&(Fld[ii][jj-1]==0))
                { ii_b=ii; jj_b=jj; mm=vv[ii*taille+jj]; }  
            }          
          }
        }
      }
    }    
  } 
  deplacer(ii_b, jj_b, false);
  lancer=false;
  if (theCol<0)
  { if ((Pot[ii_b][jj_b][2]>140)||(Pot[ii_b][jj_b][3]>140)) { poserPion(false); return; }
  	alert("Perfect! You win!");
  	document.getElementById('next').style.display='inline';
    Blink(-2);
  }
  else
  { if ((Pot[ii_b][jj_b][0]>140)||(Pot[ii_b][jj_b][1]>140)) { poserPion(false); return; }
  	alert("Try again! You can do it!");
    Blink(-2);
  }
  fini=true;
}

function testerBordures(nn, mm, cc)
{ var ii, jj;
  if (cc>0) //blue
  { if (2*mm<taille-1)
    { for (ii=0; ii<taille; ii++)
      { for (jj=0; jj<mm; jj++)
        { if ((jj-ii<mm-nn)&&(ii+jj<=nn+mm)&&(Fld[ii][jj]!=0)) return(2);
        }
      }
      if (Fld[nn-1][mm]==-cc) return(0);
      if (Fld[nn-1][mm-1]==-cc)
      { if (GetFld(nn+2,mm-1)==-cc) return(0);
        return(-1);
      }
      if (GetFld(nn+2,mm-1)==-cc) return(-2);
    }
    else
    { for (ii=0; ii<taille; ii++)
      { for (jj=taille-1; jj>mm; jj--)
        { if ((jj-ii>mm-nn)&&(ii+jj>=nn+mm)&&(Fld[ii][jj]!=0)) return(2);
        }
      }
      if (Fld[nn+1][mm]==-cc) return(0);
      if (Fld[nn+1][mm+1]==-cc)
      { if (GetFld(nn-2,mm+1)==-cc) return(0);
        return(-1);
      }
      if (GetFld(nn-2,mm+1)==-cc) return(-2); 
    }  
  }
  else
  { if (2*nn<taille-1)
    { for (jj=0; jj<taille; jj++)
      { for (ii=0; ii<nn; ii++)
        { if ((ii-jj<nn-mm)&&(ii+jj<=nn+mm)&&(Fld[ii][jj]!=0)) return(2);
        }
      }
      if (Fld[nn][mm-1]==-cc) return(0);
      if (Fld[nn-1][mm-1]==-cc)
      { if (GetFld(nn-1,mm+2)==-cc) return(0);
        return(-1);
      }
      if (GetFld(nn-1,mm+2)==-cc) return(-2);
    }
    else
    { for (jj=0; jj<taille; jj++)
      { for (ii=taille-1; ii>nn; ii--)
        { if ((ii-jj>nn-mm)&&(ii+jj>=nn+mm)&&(Fld[ii][jj]!=0)) return(2);
        }
      }
      if (Fld[nn][mm+1]==-cc) return(0);
      if (Fld[nn+1][mm+1]==-cc)
      { if (GetFld(nn+1,mm-2)==-cc) return(0);
        return(-1);
      }
      if (GetFld(nn+1,mm-2)==-cc) return(-2);  
    }  
  }  
  return(1);
}

function GetFld(ii, jj)
{ if (ii<0) return(-1);
  if (jj<0) return(1);
  if (ii>=taille) return(-1);
  if (jj>=taille) return(1);
  return(Fld[ii][jj]);
}
  
function Blink(nn)
{ lancer=true;
  if (nn==-2)
  { setTimeout("Blink(-1)",10);
    return;
  }
  if (nn==-1)
  { recupererPion(0);
    poserPion(false);
    setTimeout("Blink(0)",10);
    return;
  }    
  if (nn==14)
  { lancer=false;
    return;
  }
  var ii, jj, cc=(nn%2)*(((nbMov+Commencer)%2)*2-1);  
  for (ii=0; ii<taille; ii++)
  { for (jj=0; jj<taille; jj++)
    { if ((Pot[ii][jj][0]+Pot[ii][jj][1]<=0)||(Pot[ii][jj][2]+Pot[ii][jj][3]<=0))
      { Fld[ii][jj]=cc;
        reactiverImages(ii, jj);
      }  
    }    
  }
  setTimeout("Blink("+eval(nn+1)+")",200);
}

function recupererPion(lNiveau)
{ var ii, jj, kk, mm, mmp, nn, bb, dd=128;
  ActiveColor=((nbMov+1+Commencer)%2)*2-1;
  for (ii=0; ii<taille; ii++)
  { for (jj=0; jj<taille; jj++)
    { for (kk=0; kk<4; kk++)
      { Pot[ii][jj][kk]=20000;
        Bridge[ii][jj][kk]=0;
      }  
    }    
  }
  for (ii=0; ii<taille; ii++)
  { if (Fld[ii][0]==0) Pot[ii][0][0]=dd;//blue border
    else
    { if (Fld[ii][0]>0) Pot[ii][0][0]=0;
    }
    if (Fld[ii][taille-1]==0) Pot[ii][taille-1][1]=dd;//blue border
    else
    { if (Fld[ii][taille-1]>0) Pot[ii][taille-1][1]=0;
    }
  }
  for (jj=0; jj<taille; jj++)
  { if (Fld[0][jj]==0) Pot[0][jj][2]=dd;//red border
    else
    { if (Fld[0][jj]<0) Pot[0][jj][2]=0;
    }
    if (Fld[taille-1][jj]==0) Pot[taille-1][jj][3]=dd;//red border
    else
    { if (Fld[taille-1][jj]<0) Pot[taille-1][jj][3]=0;
    }
  }   
  for (kk=0; kk<2; kk++)//blue potential
  { for (ii=0; ii<taille; ii++)
    { for (jj=0; jj<taille; jj++)
        Upd[ii][jj]=true;
    } 
    nn=0; 
    do
    { nn++;
      bb=0;
      for (ii=0; ii<taille; ii++)
      { for (jj=0; jj<taille; jj++)
        { if (Upd[ii][jj]) bb+=SetPot(ii, jj, kk, 1, lNiveau);
        }
      }
      for (ii=taille-1; ii>=0; ii--)
      { for (jj=taille-1; jj>=0; jj--)
        { if (Upd[ii][jj]) bb+=SetPot(ii, jj, kk, 1, lNiveau);
        }
      }
    }
    while ((bb>0)&&(nn<12));
  }
  for (kk=2; kk<4; kk++)//red potential
  { for (ii=0; ii<taille; ii++)
    { for (jj=0; jj<taille; jj++)
        Upd[ii][jj]=true;
    } 
    nn=0; 
    do
    { nn++;
      bb=0;
      for (ii=0; ii<taille; ii++)
      { for (jj=0; jj<taille; jj++)
        { if (Upd[ii][jj]) bb+=SetPot(ii, jj, kk, -1, lNiveau);
        }
      }
      for (ii=taille-1; ii>=0; ii--)
      { for (jj=taille-1; jj>=0; jj--)
        { if (Upd[ii][jj]) bb+=SetPot(ii, jj, kk, -1, lNiveau);
        }
      }
    }
    while ((bb>0)&&(nn<12));
  }
}

var vv=new Array(6);
var tt=new Array(6);
function SetPot(ii, jj, kk, cc, lNiveau)
{ Upd[ii][jj]=false;
  Bridge[ii][jj][kk]=0;
  if (Fld[ii][jj]==-cc) return(0);
  var ll, mm, ddb=0, nn, oo=0, dd=140, bb=66;
  if (cc!=ActiveColor) bb=52;
  vv[0]=PotVal(ii+1,jj,kk,cc);
  vv[1]=PotVal(ii,jj+1,kk,cc);
  vv[2]=PotVal(ii-1,jj+1,kk,cc);
  vv[3]=PotVal(ii-1,jj,kk,cc);
  vv[4]=PotVal(ii,jj-1,kk,cc);
  vv[5]=PotVal(ii+1,jj-1,kk,cc);
  for (ll=0; ll<6; ll++)
  { if ((vv[ll]>=30000)&&(vv[(ll+2)%6]>=30000))
    { if (vv[(ll+1)%6]<0) ddb=+32;
      else vv[(ll+1)%6]+=128; //512;
    }
  }  
  for (ll=0; ll<6; ll++)
  { if ((vv[ll]>=30000)&&(vv[(ll+3)%6]>=30000))
    { ddb+=30;
    }
  }
  mm=30000;
  for (ll=0; ll<6; ll++)
  { if (vv[ll]<0)
    { vv[ll]+=30000;
      tt[ll]=10;
    }
    else tt[ll]=1;
    if (mm>vv[ll]) mm=vv[ll];     
  }
  nn=0;
  for (ll=0; ll<6; ll++)
  { if (vv[ll]==mm) nn+=tt[ll];
  }
  if (lNiveau>1)
  { Bridge[ii][jj][kk]=nn/5;
    if ((nn>=2)&&(nn<10)) { Bridge[ii][jj][kk]=bb+nn-2; mm-=32; }
    if (nn<2)
    { oo=30000;
      for (ll=0; ll<6; ll++)
      { if ((vv[ll]>mm)&&(oo>vv[ll])) oo=vv[ll];     
      }
      if (oo<=mm+104) { Bridge[ii][jj][kk]=bb-(oo-mm)/4; mm-=64; }
      mm+=oo;
      mm/=2;
    }
  }
  
  if ((ii>0)&&(ii<taille-1)&&(jj>0)&&(jj<taille-1)) Bridge[ii][jj][kk]+=ddb;
  else Bridge[ii][jj][kk]-=2;
  if (((ii==0)||(ii==taille-1))&&((jj==0)||(jj==taille-1))) Bridge[ii][jj][kk]/=2; // /=4
  if (Bridge[ii][jj][kk]>68) Bridge[ii][jj][kk]=68; //66
  
  if (Fld[ii][jj]==cc)
  { if (mm<Pot[ii][jj][kk]) 
    { Pot[ii][jj][kk]=mm;
      modifier(ii+1,jj,cc);
      modifier(ii,jj+1,cc);
      modifier(ii-1,jj+1,cc);
      modifier(ii-1,jj,cc);
      modifier(ii,jj-1,cc);
      modifier(ii+1,jj-1,cc);
      return(1);
    }  
    return(0);
  }
  if (mm+dd<Pot[ii][jj][kk]) 
  { Pot[ii][jj][kk]=mm+dd;
    modifier(ii+1,jj,cc);
    modifier(ii,jj+1,cc);
    modifier(ii-1,jj+1,cc);
    modifier(ii-1,jj,cc);
    modifier(ii,jj-1,cc);
    modifier(ii+1,jj-1,cc);  
    return(1);
  }  
  return(0);
}

function PotVal(ii,jj,kk,cc)
{ if (ii<0) return(30000);
  if (jj<0) return(30000);
  if (ii>=taille) return(30000);
  if (jj>=taille) return(30000);
  if (Fld[ii][jj]==0) return(Pot[ii][jj][kk]);
  if (Fld[ii][jj]==-cc) return(30000);
  return(Pot[ii][jj][kk]-30000);
}

function modifier(ii,jj,cc)
{ if (ii<0) return;
  if (jj<0) return;
  if (ii>=taille) return;
  if (jj>=taille) return;
  Upd[ii][jj]=true;
}

function cliquer(ii, jj)
{ if (fini) return;
  if (lancer) { Action="cliquer("+ii+","+jj+")"; return; }  
  if (Fld[ii][jj]!=0) 
  {
	  return;
  }  
  if (! joueur[(nbMov+Commencer+1)%2]) return;
  deplacer(ii, jj, true);
}  

function reactiverImages(ii, jj)
{ window.document.images[ImgNum[ii][jj]].src = Pic[1+Fld[ii][jj]].src;
}

function reactiverBoard()
{ for (ii=0; ii<taille; ii++)
  { for (jj=0; jj<taille; jj++)
    document.images[ImgNum[ii][jj]].src = Pic[1+Fld[ii][jj]].src;
  }
}
//**********************une fonction qui permet de redimensionner la fenetre selon le navigateur
function Redimensionner()
{ if(navigator.appName == "Netscape") history.go(0);
}
//************************une fonction qui permet de donner des renseignement
function info(){
	  alert("Welcome to Hex !"+
    		  "\nBuild a path of hexes between two slides red of the board."+
    		  "\nComputer will try to do the same with the blue borders."+ 
    		  "\nEach turn you can color one empty hex."+
    		  "\nEnjoy!");
}
</script>
</head>
<body bgcolor=#DCDCDC text=#000000 onResize="javascript:Redimensionner()" onload="javascript:info()">
<div>
<form>
<table>
<tr>
  <td><table class="fond" cellpadding=10 cellspacing=0 align=center><tr><td background="./images/hex_bg.gif" align=center><font size=1>
      <script language="JavaScript">
      k=0;
      for (i=0; i < taille; i++)
      { document.write("<nobr>");
        for (j=0; j <= i; j++)      
        { document.write("<IMG src=\"./images/hex_t.gif\" border=0 onMouseDown=\"cliquer("+eval(i-j)+","+j+")\" title='"+String.fromCharCode(65+j)+eval(i-j+1)+"' alt='"+String.fromCharCode(65+j)+eval(i-j+1)+"'>");
          ImgNum[i-j][j]=k++;
        }  
        document.writeln("</nobr><br>");
      }
      for (i=taille-2; i >= 0; i--)
      { document.write("<nobr>");
        for (j=0; j <= i; j++)      
        { document.write("<IMG src=\"./images/hex_t.gif\" border=0 onMouseDown=\"cliquer("+eval(taille-1-j)+","+eval(taille-1-i+j)+")\" title='"+String.fromCharCode(65+taille-1-i+j)+eval(taille-j)+"' alt='"+String.fromCharCode(65+taille-1-i+j)+eval(taille-j)+"'>");
          ImgNum[taille-1-j][taille-1-i+j]=k++;
        }  
        document.writeln("</nobr><br>");
      }
      //Le bleu commence en premier
      SetOption(2,0);
      //machine a la couleur bleu
      SetOption(1,1);
      //le joueur a la couleur rouge
      SetOption(0,0);
      //le niveau 1 du jeu
      SetNiveau(1,1);
      SetNiveau(0,1);
      </script>
      </font></td></tr></table>
  </td>
</tr>
<tr>
<td><input  type="button" class="restart" name="restart"  value="Restart" onClick="javascript:initialiser()">
<input  type="button" class="return" name="return"  value="Back to menu" onclick="window.location.href='menu.jsp';">
<input  type="button" class="next" id="next" name="next" style="display:none;" value="Next" onclick="window.location.href='board2.jsp';"></td>
</tr>
</table>
</form>
</div>
<script type="text/javascript">
  initialiser();
  setInterval("minuteur()",200);
</script>
</body>
</html>
