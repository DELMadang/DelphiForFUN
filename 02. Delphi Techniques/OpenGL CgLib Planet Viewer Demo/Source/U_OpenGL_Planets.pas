unit U_OpenGL_Planets;

// Composite modeling transformations - converted from planet.c but added a moon
// to the planet.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, CgWindow, CgTypes, CgLight, GL, GLu, Glut, StdCtrls, NumEdit,
  Spin;

type
  TPForm = class(TForm)
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Xedit: TSpinEdit;
    Label1: TLabel;
    YEdit: TSpinEdit;
    ZEdit: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    HoursInc: TSpinEdit;
    Label4: TLabel;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure setview;
  end;

const
  hours: GLFLoat = 0;
  days: GLfloat = 0;
  years: GLFLoat =0;

var
  PForm: TPForm;
  L: TCGLight;
  CgDC1: TCGDeviceContext;

implementation

{$R *.DFM}
const

  lpos: TCGVector = (x: 0; y: 0; z: 0; w: 1);
  lcol: TCGColorF = (R: 1; G: 0.75; B: 1; A: 1);

procedure TPForm.FormCreate(Sender: TObject);

var
 pDC:HDC;
begin
  {This gets a device context for the panel}
  pDC := GetDC(Panel1.Handle);
  CgDC1 := TCGDeviceContext.Create(pDC);
  CgDC1.InitGL;  {and initializes OpenGL on the panel}

  glEnable(GL_DEPTH_TEST);
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
  glEnable(GL_AUTO_NORMAL);
  glEnable(GL_NORMALIZE);

  L := TCGLight.Create(GL_LIGHT0);
  L.Position := lpos;
  L.Diffuse := lcol;
  L.Enable;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  with panel1 do
  gluPerspective(60.0,Width/Height, 1.0, 20.0);
  gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
  glMatrixMode(GL_MODELVIEW);
end;



procedure TPForm.setview;
begin
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  with panel1 do
  gluPerspective(60.0, ClientWidth/ClientHeight, 1.0, 20.0);

  gluLookAt(0, 0, zedit.value, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
  glrotatef(xedit.value,0,1,0);
  glrotatef(yedit.value,1,0,0);
  glMatrixMode(GL_MODELVIEW);
end;

procedure TPForm.FormPaint(Sender: TObject);
const
  sColor: array [0..3] of GLfloat = (1, 0.85, 0, 1);
  pColor: array [0..3] of GLfloat = (0.0, 0.0, 0.8, 1);
  mColor: array [0..3] of GLfloat = (0.5, 0.5, 0.6, 1);
  spec: array [0..3] of GLfloat = (0.5, 0.5, 0.5, 0.5);
  black: array [0..3] of GLfloat = (0, 0, 0, 1);
  brown: array [0..3] of GLfloat = (0.4, 0.4, 0.2, 1);
var
  deltamoon:GLFloat;
begin
  cgDC1.MakeCurrent;
  Setview;
  glClear(GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT);
  glLoadIdentity;
  // Making the objects shiny looks bogus, but at least you can tell they're rotating.
  glMaterialf(GL_FRONT, GL_SHININESS, 100);
  glMaterialfv(GL_FRONT, GL_SPECULAR, @spec[0]);

  glPushMatrix;                     // "Remember where we are"

  glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, @sColor);
  glutSolidSphere(0.4, 32, 16);     // Draw the sun
  glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, @brown {black});

  glRotatef(360*years , 0.0, 1.0, 0.0);   // Rotate the planet around the sun.
  glTranslatef(2.4, 0.0, 0.0);      // Translate it to a point on its orbit.
  // We now need to remember the planet's position before we rotate it around
  // it's own axis. If we PushMatrix later, the moon's orbit will also rotate
  // around the planet's axis!
  glPushMatrix;
                     // Remember the planet's position.
  glRotatef(23, 0.0, 0.0, 1.0);    // Tilt the planet's axis 20 degrees.
  glRotatef( (15*hours), 0.0, 1.0, 0.0);    // Rotate it around its own axis.
  // Note how the transformations seem to take place in reverse order!

  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @pColor);
  glutSolidSphere(0.2, 16{32}, 8{16});     // Draw the planet.

  glPopMatrix;                      // Return to planet position.
  glRotatef(10, 0.0, 0.0, 1.0);     // Tilt the moon's orbit
  deltamoon:=360*12*years;
  glRotatef(deltamoon, 0.0, 1.0, 0.0); // Rotate the moon around the planet - 12 degrees per day.
  glTranslatef(0.35, 0.0, 0.0);      // Translate it to a point on its orbit.
  glRotatef(-deltamoon, 0.0, 1.0, 0.0);    // Rotate it back around its own axis.

  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @mColor);
  glutSolidSphere(0.08, 16{32}, 8{16});      // Draw the moon.

  glPopMatrix;                      // Restore the original matrix.

  cgDC1.PageFlip;

end;

procedure TPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CgDC1.Free;
  L.Free;

end;

const
  daysperyear=364.25;

procedure TPForm.Timer1Timer(Sender: TObject);
begin
  {here are most of my changes original was 1 degre per step}
  hours:=(hours+hoursinc.value);
  if hours>=24*daysperyear then hours:=hours-24*daysperyear;
  days:=hours / 24;
  years:=days/daysperyear;

  Paint;

end;

end.

