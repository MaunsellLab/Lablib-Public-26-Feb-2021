FasdUAS 1.101.10   ��   ��    k             l     ��  ��    ? 9 clone Project  v. 4.0  app script   (Xcode 9 compatible)     � 	 	 r   c l o n e   P r o j e c t     v .   4 . 0     a p p   s c r i p t       ( X c o d e   9   c o m p a t i b l e )   
  
 l     ��  ��     
 JHRM 2018     �      J H R M   2 0 1 8      l     ��  ��     y This is a bit of a dog's meal, because it was written making a lot of assumptions about which folders files would be in.     �   �   T h i s   i s   a   b i t   o f   a   d o g ' s   m e a l ,   b e c a u s e   i t   w a s   w r i t t e n   m a k i n g   a   l o t   o f   a s s u m p t i o n s   a b o u t   w h i c h   f o l d e r s   f i l e s   w o u l d   b e   i n .      l     ��  ��    } w Things have changed a lot since then.  It would be a good thing to refactor this sometime.  The main improvement would     �   �   T h i n g s   h a v e   c h a n g e d   a   l o t   s i n c e   t h e n .     I t   w o u l d   b e   a   g o o d   t h i n g   t o   r e f a c t o r   t h i s   s o m e t i m e .     T h e   m a i n   i m p r o v e m e n t   w o u l d      l     ��  ��    } w come from following a path that processed each subfolder individually, in a nested way.  Currently the file list goes      �   �   c o m e   f r o m   f o l l o w i n g   a   p a t h   t h a t   p r o c e s s e d   e a c h   s u b f o l d e r   i n d i v i d u a l l y ,   i n   a   n e s t e d   w a y .     C u r r e n t l y   t h e   f i l e   l i s t   g o e s        l     ��   !��     z t only one level deep, and it makes assumptions about what will be found where.  It is not robust to future changes.     ! � " " �   o n l y   o n e   l e v e l   d e e p ,   a n d   i t   m a k e s   a s s u m p t i o n s   a b o u t   w h a t   w i l l   b e   f o u n d   w h e r e .     I t   i s   n o t   r o b u s t   t o   f u t u r e   c h a n g e s .     # $ # l     �� % &��   % a [ A little bit of careful organization would make this script much smaller and more robust.     & � ' ' �   A   l i t t l e   b i t   o f   c a r e f u l   o r g a n i z a t i o n   w o u l d   m a k e   t h i s   s c r i p t   m u c h   s m a l l e r   a n d   m o r e   r o b u s t .   $  ( ) ( l     ��������  ��  ��   )  * + * l     ��������  ��  ��   +  , - , l     �� . /��   . = 7 need to get "kOP" converted as well in .m and .h files    / � 0 0 n   n e e d   t o   g e t   " k O P "   c o n v e r t e d   a s   w e l l   i n   . m   a n d   . h   f i l e s -  1 2 1 l     ��������  ��  ��   2  3 4 3 l     �� 5 6��   5   Global variables    6 � 7 7 "   G l o b a l   v a r i a b l e s 4  8 9 8 l      : ; < : j     �� =�� 0 	nibfolder 	nibFolder = m      > > � ? ?  E n g l i s h . l p r o j ; B < location of Interface Builder files in Xcode project folder    < � @ @ x   l o c a t i o n   o f   I n t e r f a c e   B u i l d e r   f i l e s   i n   X c o d e   p r o j e c t   f o l d e r 9  A B A l      C D E C j    �� F�� 0 	xibfolder 	xibFolder F m     G G � H H  B a s e . l p r o j D 1 + modern location of Interface Builder files    E � I I V   m o d e r n   l o c a t i o n   o f   I n t e r f a c e   B u i l d e r   f i l e s B  J K J l      L M N L j    �� O�� 0 matlabfolder matlabFolder O m     P P � Q Q  M a t l a b M   location of Matlab files    N � R R 2   l o c a t i o n   o f   M a t l a b   f i l e s K  S T S l      U V W U j   	 �� X�� &0 replacescriptname replaceScriptName X m   	 
 Y Y � Z Z  m y s c r i p t . t x t V = 7 file created containing sed script for unix bash shell    W � [ [ n   f i l e   c r e a t e d   c o n t a i n i n g   s e d   s c r i p t   f o r   u n i x   b a s h   s h e l l T  \ ] \ l      ^ _ ` ^ j    �� a��  0 oldprojectname oldProjectName a m     b b � c c  o l d p r o j e c t _ 6 0 project folder name of project to be duplicated    ` � d d `   p r o j e c t   f o l d e r   n a m e   o f   p r o j e c t   t o   b e   d u p l i c a t e d ]  e f e l      g h i g j    �� j�� 0 mypath myPath j m     k k � l l  / U s e r s / h 1 + POSIX path to location of files or folders    i � m m V   P O S I X   p a t h   t o   l o c a t i o n   o f   f i l e s   o r   f o l d e r s f  n o n l      p q r p j    �� s�� 0 
filesuffix 
fileSuffix s m     t t � u u  . p l i s t q ( " file suffix changed with context     r � v v D   f i l e   s u f f i x   c h a n g e d   w i t h   c o n t e x t   o  w x w l      y z { y p     | | ������ 0 filelist fileList��   z 9 3  all Files found in project folder and sub folders    { � } } f     a l l   F i l e s   f o u n d   i n   p r o j e c t   f o l d e r   a n d   s u b   f o l d e r s x  ~  ~ p     � � ������ 0 kernel_beginning  ��     � � � l     �� � ���   �   list of illegal prefixes    � � � � 2   l i s t   o f   i l l e g a l   p r e f i x e s �  � � � l     ����� � r      � � � J      � �  � � � m      � � � � �  N S �  � � � m     � � � � �  N S S �  � � � m     � � � � �  V B L �  � � � m     � � � � �  V B L C �  � � � m     � � � � �  L L �  � � � m     � � � � �  C C �  � � � m     � � � � �  G G �  � � � m     � � � � �  P B �  � � � m    	 � � � � �  P B X �  � � � m   	 
 � � � � �  P B X F �  � � � m   
  � � � � �  P B X V �  � � � m     � � � � �  P B X B �  � � � m     � � � � �  I T �  � � � m     � � � � �  I T C �  � � � m     � � � � �  B O �  � � � m     � � � � �  B O O �  ��� � m     � � � � �  B O O L��   � o      ����  0 myreservedlist myReservedList��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �  //////////  subroutines    � � � � . / / / / / / / / / /     s u b r o u t i n e s �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � ? 9 doOneFolder: input argument is a Finder folder reference    � � � � r   d o O n e F o l d e r :   i n p u t   a r g u m e n t   i s   a   F i n d e r   f o l d e r   r e f e r e n c e �  � � � i    � � � I      �� ����� 0 doonefolder doOneFolder �  � � � o      ���� 0 	thefolder 	theFolder �  � � � o      ���� 0 	buildpath 	buildPath �  � � � o      ���� 0 
old_prefix   �  � � � o      ���� 0 
new_prefix   �  � � � o      ����  0 oldprojectname oldProjectName �  ��� � o      ����  0 newprojectname newProjectName��  ��   � k     � �  � � � l     �� � ���   � - ' Process subfolders first (recursively)    � � � � N   P r o c e s s   s u b f o l d e r s   f i r s t   ( r e c u r s i v e l y ) �  � � � O      � � � l    � � � � r     � � � l   
 ����� � e    
 � � n    
 � � � 1    	��
�� 
pnam � n      2    ��
�� 
cfol o    ���� 0 	thefolder 	theFolder��  ��   � o      ���� 0 
folderlist 
folderList � ' ! get a list of all the subfolders    � � B   g e t   a   l i s t   o f   a l l   t h e   s u b f o l d e r s � m     �                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��   �  Y    6���� k    1		 

 l   ����    set oldMyPath to myPath    � . s e t   o l d M y P a t h   t o   m y P a t h  l   ����   = 7set myPath to myPath & (item f of folderList) as string    � n s e t   m y P a t h   t o   m y P a t h   &   ( i t e m   f   o f   f o l d e r L i s t )   a s   s t r i n g  l   ����   U Oset cmd to "cd " & (POSIX path of (theFolder as text)) & (item f of folderList)    � � s e t   c m d   t o   " c d   "   &   ( P O S I X   p a t h   o f   ( t h e F o l d e r   a s   t e x t ) )   &   ( i t e m   f   o f   f o l d e r L i s t )  l   ����    display dialog myPath    � * d i s p l a y   d i a l o g   m y P a t h  I    /�� ���� 0 doonefolder doOneFolder  !"! c    &#$# l   $%����% b    $&'& l   (����( c    )*) o    ���� 0 	thefolder 	theFolder* m    ��
�� 
ctxt��  ��  ' l   #+����+ n    #,-, 4     #��.
�� 
cobj. o   ! "���� 0 f  - o     ���� 0 
folderlist 
folderList��  ��  ��  ��  $ m   $ %��
�� 
alis" /0/ o   & '���� 0 	buildpath 	buildPath0 121 o   ' (���� 0 
old_prefix  2 343 o   ( )���� 0 
new_prefix  4 565 o   ) *����  0 oldprojectname oldProjectName6 7��7 o   * +����  0 newprojectname newProjectName��  ��   898 l  0 0��:;��  : v pdoOneFoflder((item f of folderList) as alias, buildPath, old_prefix, new_prefix, oldProjectName, newProjectName)   ; �<< � d o O n e F o f l d e r ( ( i t e m   f   o f   f o l d e r L i s t )   a s   a l i a s ,   b u i l d P a t h ,   o l d _ p r e f i x ,   n e w _ p r e f i x ,   o l d P r o j e c t N a m e ,   n e w P r o j e c t N a m e )9 =>= l  0 0��?@��  ? l fdoOneFolder((item f of folderList), buildPath, old_prefix, new_prefix, oldProjectName, newProjectName)   @ �AA � d o O n e F o l d e r ( ( i t e m   f   o f   f o l d e r L i s t ) ,   b u i l d P a t h ,   o l d _ p r e f i x ,   n e w _ p r e f i x ,   o l d P r o j e c t N a m e ,   n e w P r o j e c t N a m e )> B��B l  0 0��CD��  C  set myPath to oldMyPath   D �EE . s e t   m y P a t h   t o   o l d M y P a t h��  �� 0 f   m    ����  n    FGF 1    ��
�� 
lengG o    ���� 0 
folderlist 
folderList��   HIH l  7 7��JK��  J X R Once the subfolders have been processed, process each of the files in this folder   K �LL �   O n c e   t h e   s u b f o l d e r s   h a v e   b e e n   p r o c e s s e d ,   p r o c e s s   e a c h   o f   t h e   f i l e s   i n   t h i s   f o l d e rI M��M O   7NON k   ;PP QRQ r   ; CSTS e   ; AUU n   ; AVWV 1   > @��
�� 
pnamW n  ; >XYX 2   < >��
�� 
fileY o   ; <���� 0 	thefolder 	theFolderT o      ���� 0 filelist fileListR Z[Z I  D I��\��
�� .corecnte****       ****\ 1   D E��
�� 
rslt��  [ ]^] r   J M_`_ 1   J K��
�� 
rslt` o      ���� 0 numfiles numFiles^ aba l  N Ucdec n   N Ufgf I   O U��h����  0 prepareprogbar prepareProgBarh iji o   O P���� 0 numfiles numFilesj k��k m   P Q���� ��  ��  g  f   N Od   Prepare Progress Bar   e �ll *   P r e p a r e   P r o g r e s s   B a rb mnm l  V \opqo n   V \rsr I   W \��t���� 0 fadeinprogbar fadeinProgBart u��u m   W X���� ��  ��  s  f   V Wp 2 , Open the desired Progress Bar window style.   q �vv X   O p e n   t h e   d e s i r e d   P r o g r e s s   B a r   w i n d o w   s t y l e .n wxw l  ] ]��yz��  y F @ rename prefixes within files  and file names of project files     z �{{ �   r e n a m e   p r e f i x e s   w i t h i n   f i l e s     a n d   f i l e   n a m e s   o f   p r o j e c t   f i l e s    x |}| Y   ]~�����~ l  g���� k   g�� ��� l  g o���� n   g o��� I   h o������� $0 incrementprogbar incrementProgBar� ��� o   h i���� 0 n  � ��� o   i j���� 0 numfiles numFiles� ���� m   j k���� ��  ��  �  f   g h� !  Increment the progress bar   � ��� 6   I n c r e m e n t   t h e   p r o g r e s s   b a r� ��� l  p w���� r   p w��� l  p u������ e   p u�� n   p u��� 4   q t���
�� 
cobj� o   r s���� 0 n  � o   p q���� 0 filelist fileList��  ��  � o      ���� 0 currentfile currentFile� #  Get the next file to process   � ��� :   G e t   t h e   n e x t   f i l e   t o   p r o c e s s� ��� l  x ����� r   x ���� b   x ���� l  x {����� c   x {��� o   x y�~�~ 0 	thefolder 	theFolder� m   y z�}
�} 
ctxt��  �  � l  { ��|�{� n   { ��� 4   | �z�
�z 
cobj� o   } ~�y�y 0 n  � o   { |�x�x 0 filelist fileList�|  �{  � o      �w�w &0 pathtocurrentfile pathToCurrentFile� #  Get the next file to process   � ��� :   G e t   t h e   n e x t   f i l e   t o   p r o c e s s� ��v� Z   ����u�� C   � ���� o   � ��t�t 0 currentfile currentFile� o   � ��s�s 0 
old_prefix  � l  �o���� k   �o�� ��� Z   �m���r�� H   � ��� C   � ���� o   � ��q�q 0 currentfile currentFile� o   � ��p�p  0 oldprojectname oldProjectName� l  � ����� k   � ��� ��� l  � ����� r   � ���� m   � ��� ���  � o      �o�o 0 filename_kernel  � &   extract filename without prefix   � ��� @   e x t r a c t   f i l e n a m e   w i t h o u t   p r e f i x� ��� Y   � ���n���m� r   � ���� b   � ���� o   � ��l�l 0 filename_kernel  � l  � ���k�j� n   � ���� 4   � ��i�
�i 
cobj� o   � ��h�h 0 n  � o   � ��g�g 0 currentfile currentFile�k  �j  � o      �f�f 0 filename_kernel  �n 0 n  � o   � ��e�e 0 kernel_beginning  � l  � ���d�c� I  � ��b��a
�b .corecnte****       ****� o   � ��`�` 0 currentfile currentFile�a  �d  �c  �m  � ��� l  � ����� n  � ���� I   � ��_��^�_ &0 replacetextinfile replaceTextInFile� ��� c   � ���� o   � ��]�] 0 	thefolder 	theFolder� m   � ��\
�\ 
ctxt� ��� o   � ��[�[ 0 currentfile currentFile� ��� o   � ��Z�Z  0 oldprojectname oldProjectName� ��� o   � ��Y�Y  0 newprojectname newProjectName� ��� o   � ��X�X 0 
old_prefix  � ��W� o   � ��V�V 0 
new_prefix  �W  �^  �  f   � ��   replace prefixes in file   � ��� 2   r e p l a c e   p r e f i x e s   i n   f i l e� ��U� l  � ����� r   � ���� l  � ���T�S� b   � ���� o   � ��R�R 0 
new_prefix  � o   � ��Q�Q 0 filename_kernel  �T  �S  � n      � � 1   � ��P
�P 
pnam  n   � � 4   � ��O
�O 
docf o   � ��N�N 0 currentfile currentFile o   � ��M�M 0 	thefolder 	theFolder� "  change the name of the file   � � 8   c h a n g e   t h e   n a m e   o f   t h e   f i l e�U  � < 6 If user did not start project name with the prefix...   � � l   I f   u s e r   d i d   n o t   s t a r t   p r o j e c t   n a m e   w i t h   t h e   p r e f i x . . .�r  � l  �m Z   �m	
�L	 D   � � o   � ��K�K 0 currentfile currentFile m   � � �  . x c o d e p r o j
 l  � � r   � � b   � � o   � ��J�J  0 newprojectname newProjectName m   � � �  . x c o d e p r o j n       1   � ��I
�I 
pnam n   � � 4   � ��H
�H 
docf o   � ��G�G 0 currentfile currentFile o   � ��F�F 0 	thefolder 	theFolder A ; non-special case were project name does not include prefix    � v   n o n - s p e c i a l   c a s e   w e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i x   D   � �!"! o   � ��E�E 0 currentfile currentFile" m   � �## �$$  . p c h  %&% l  � '()' r   � *+* b   � �,-, o   � ��D�D  0 newprojectname newProjectName- m   � �.. �//  _ P r e f i x . p c h+ n      010 1   � ��C
�C 
pnam1 n   � �232 4   � ��B4
�B 
docf4 o   � ��A�A 0 currentfile currentFile3 o   � ��@�@ 0 	thefolder 	theFolder( %  precompiled header for project   ) �55 >   p r e c o m p i l e d   h e a d e r   f o r   p r o j e c t& 676 D  898 o  �?�? 0 currentfile currentFile9 m  :: �;;  . m7 <=< l 5>?@> k  5AA BCB n DED I  �>F�=�> &0 replacetextinfile replaceTextInFileF GHG c  IJI o  �<�< 0 	thefolder 	theFolderJ m  �;
�; 
ctxtH KLK o  �:�: 0 currentfile currentFileL MNM o  �9�9  0 oldprojectname oldProjectNameN OPO o  �8�8  0 newprojectname newProjectNameP QRQ o  �7�7 0 
old_prefix  R S�6S o  �5�5 0 
new_prefix  �6  �=  E  f  C T�4T Z  5UV�3�2U =  WXW o  �1�1 0 currentfile currentFileX l Y�0�/Y b  Z[Z o  �.�.  0 oldprojectname oldProjectName[ m  \\ �]]  . m�0  �/  V r  #1^_^ b  #(`a` o  #$�-�-  0 newprojectname newProjectNamea m  $'bb �cc  . m_ n      ded 1  .0�,
�, 
pname n  (.fgf 4  ).�+h
�+ 
docfh o  ,-�*�* 0 currentfile currentFileg o  ()�)�) 0 	thefolder 	theFolder�3  �2  �4  ? "  principal class for project   @ �ii 8   p r i n c i p a l   c l a s s   f o r   p r o j e c t= jkj D  8=lml o  89�(�( 0 currentfile currentFilem m  9<nn �oo  . hk pqp l @�rstr k  @�uu vwv n @Mxyx I  AM�'z�&�' &0 replacetextinfile replaceTextInFilez {|{ c  AD}~} o  AB�%�% 0 	thefolder 	theFolder~ m  BC�$
�$ 
ctxt| � o  DE�#�# 0 currentfile currentFile� ��� o  EF�"�"  0 oldprojectname oldProjectName� ��� o  FG�!�!  0 newprojectname newProjectName� ��� o  GH� �  0 
old_prefix  � ��� o  HI�� 0 
new_prefix  �  �&  y  f  @Aw ��� Z  N������ = NU��� o  NO�� 0 currentfile currentFile� l OT���� b  OT��� o  OP��  0 oldprojectname oldProjectName� m  PS�� ���  . h�  �  � l Xf���� r  Xf��� b  X]��� o  XY��  0 newprojectname newProjectName� m  Y\�� ���  . h� n      ��� 1  ce�
� 
pnam� n  ]c��� 4  ^c��
� 
docf� o  ab�� 0 currentfile currentFile� o  ]^�� 0 	thefolder 	theFolder�    should only happen once		   � ��� 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	� ��� = ip��� o  ij�� 0 currentfile currentFile� l jo���� b  jo��� o  jk��  0 oldprojectname oldProjectName� m  kn�� ���  _ P r e f i x . h�  �  � ��� l s����� r  s���� b  sx��� o  st��  0 newprojectname newProjectName� m  tw�� ���  _ P r e f i x . h� n      ��� 1  ~��
� 
pnam� n  x~��� 4  y~��
� 
docf� o  |}�
�
 0 currentfile currentFile� o  xy�	�	 0 	thefolder 	theFolder�   should only happen once	   � ��� 2   s h o u l d   o n l y   h a p p e n   o n c e 	�  �  �  s , & header of principal class for project   t ��� L   h e a d e r   o f   p r i n c i p a l   c l a s s   f o r   p r o j e c tq ��� =  ����� o  ���� 0 currentfile currentFile� b  ����� o  ����  0 oldprojectname oldProjectName� m  ���� ���  . n i b� ��� l ������ r  ����� b  ����� o  ����  0 newprojectname newProjectName� m  ���� ���  . n i b� n      ��� 1  ���
� 
pnam� n  ����� 4  ����
� 
docf� o  ���� 0 currentfile currentFile� n  ����� 4  ����
� 
cfol� o  ���� 0 	nibfolder 	nibFolder� o  ��� �  0 	thefolder 	theFolder�    principal nib for project   � ��� 4   p r i n c i p a l   n i b   f o r   p r o j e c t� ��� =  ����� o  ������ 0 currentfile currentFile� b  ����� o  ������  0 oldprojectname oldProjectName� m  ���� ���  . x i b� ��� l ������ k  ���� ��� n ����� I  ��������� &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ������ 0 	thefolder 	theFolder� m  ����
�� 
ctxt� ��� o  ������ 0 currentfile currentFile� ��� o  ������  0 oldprojectname oldProjectName� ��� o  ������  0 newprojectname newProjectName� ��� o  ������ 0 
old_prefix  � ���� o  ������ 0 
new_prefix  ��  ��  �  f  ��� ���� r  ����� b  ����� o  ������  0 newprojectname newProjectName� m  ���� ���  . x i b� n      � � 1  ����
�� 
pnam  n  �� 4  ����
�� 
docf o  ������ 0 currentfile currentFile o  ������ 0 	thefolder 	theFolder��  �    principal xib for project   � � 4   p r i n c i p a l   x i b   f o r   p r o j e c t�  D  �� o  ������ 0 currentfile currentFile m  ��		 �

  . p l i s t �� l �i k  �i  r  �� m  �� �  . p l i s t o      ���� 0 
filesuffix 
fileSuffix  n �� I  �������� &0 replacetextinfile replaceTextInFile  c  �� o  ������ 0 	thefolder 	theFolder m  ����
�� 
ctxt   o  ������ 0 currentfile currentFile  !"! o  ������  0 oldprojectname oldProjectName" #$# o  ������  0 newprojectname newProjectName$ %&% o  ������ 0 
old_prefix  & '��' o  ������ 0 
new_prefix  ��  ��    f  �� ()( r  ��*+* I ����,��
�� .sysoctonshor       TEXT, l ��-����- n  ��./. 4 ����0
�� 
cobj0 m  ������ / o  ������  0 oldprojectname oldProjectName��  ��  ��  + o      ���� 0 testchar testChar) 121 Z  �E34����3 F  �565 @  �787 o  ������ 0 testchar testChar8 m  ����� A6 B  9:9 o  ���� 0 testchar testChar: m  
���� Z4 l A;<=; k  A>> ?@? r  ABA m  CC �DD  B o      ���� 
0 locase  @ EFE Y  3G��HI��G r  &.JKJ b  &,LML o  &'���� 
0 locase  M l '+N����N n  '+OPO 4  (+��Q
�� 
cobjQ o  )*���� 0 n  P o  '(����  0 oldprojectname oldProjectName��  ��  K o      ���� 
0 locase  �� 0 n  H m  ���� I l !R����R I !��S��
�� .corecnte****       ****S o  ����  0 oldprojectname oldProjectName��  ��  ��  ��  F T��T r  4AUVU b  4?WXW l 4=Y����Y I 4=��Z��
�� .sysontocTEXT       shorZ l 49[����[ [  49\]\ o  45���� 0 testchar testChar] m  58����  ��  ��  ��  ��  ��  X o  =>���� 
0 locase  V o      ���� 
0 locase  ��  <   is it uppercase ?   = �^^ $   i s   i t   u p p e r c a s e   ?��  ��  2 _`_ l FNabca n FNded I  GN��f���� &0 simplereplacetext simpleReplaceTextf ghg o  GH���� 0 currentfile currentFileh iji o  HI���� 
0 locase  j k��k o  IJ����  0 newprojectname newProjectName��  ��  e  f  FGb 7 1 catch any lowercase instances of project name 		   c �ll b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 	` mnm l OO��op��  o ; 5 rename only .plist files containing the projectname    p �qq j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  n r��r r  Oists l O`u����u I O`��vw�� 0 searchreplace searchReplacev  f  OPw ��xy
�� 
intox o  ST���� 0 currentfile currentFiley ��z{
�� 
at  z o  WX����  0 oldprojectname oldProjectName{ ��|���� 0 replacestring replaceString| o  [\����  0 newprojectname newProjectName��  ��  ��  t n      }~} 1  fh��
�� 
pnam~ n  `f� 4  af���
�� 
docf� o  de���� 0 currentfile currentFile� o  `a���� 0 	thefolder 	theFolder��      property list for project    ��� 4   p r o p e r t y   l i s t   f o r   p r o j e c t��  �L   , & old project name includes old prefix     ��� L   o l d   p r o j e c t   n a m e   i n c l u d e s   o l d   p r e f i x  � ���� l nn��������  ��  ��  ��  � , & If its name has got the old prefix...   � ��� L   I f   i t s   n a m e   h a s   g o t   t h e   o l d   p r e f i x . . .�u  � l r���� Z  r������ D  rw��� o  rs���� 0 currentfile currentFile� m  sv�� ���  . x c o d e p r o j� l z����� r  z���� b  z��� o  z{����  0 newprojectname newProjectName� m  {~�� ���  . x c o d e p r o j� n      ��� 1  ����
�� 
pnam� n  ���� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ����� 0 	thefolder 	theFolder� B < non-special case where project name does not include prefix   � ��� x   n o n - s p e c i a l   c a s e   w h e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i x� ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . p c h� ��� r  ����� b  ����� o  ������  0 newprojectname newProjectName� m  ���� ���  _ P r e f i x . p c h� n      ��� 1  ����
�� 
pnam� n  ����� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	thefolder 	theFolder� ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . m� ��� k  ���� ��� n ����� I  ��������� &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ������ 0 	thefolder 	theFolder� m  ����
�� 
ctxt� ��� o  ������ 0 currentfile currentFile� ��� o  ������  0 oldprojectname oldProjectName� ��� o  ������  0 newprojectname newProjectName� ��� o  ������ 0 
old_prefix  � ���� o  ������ 0 
new_prefix  ��  ��  �  f  ��� ���� Z  ��������� = ����� o  ������ 0 currentfile currentFile� l �������� b  ����� o  ����  0 oldprojectname oldProjectName� m  ���� ���  . m��  ��  � l ������ r  ����� b  ����� o  ���~�~  0 newprojectname newProjectName� m  ���� ���  . m� n      ��� 1  ���}
�} 
pnam� n  ����� 4  ���|�
�| 
docf� o  ���{�{ 0 currentfile currentFile� o  ���z�z 0 	thefolder 	theFolder�   should only happen once   � ��� 0   s h o u l d   o n l y   h a p p e n   o n c e��  ��  ��  � ��� D  ����� o  ���y�y 0 currentfile currentFile� m  ���� ���  . h� ��� k  �&�� ��� n ����� I  ���x��w�x &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ���v�v 0 	thefolder 	theFolder� m  ���u
�u 
ctxt� ��� o  ���t�t 0 currentfile currentFile� ��� o  ���s�s  0 oldprojectname oldProjectName� ��� o  ���r�r  0 newprojectname newProjectName� ��� o  ���q�q 0 
old_prefix  �  �p  o  ���o�o 0 
new_prefix  �p  �w  �  f  ��� �n Z  �&�m = �� o  ���l�l 0 currentfile currentFile l ���k�j b  ��	 o  ���i�i  0 oldprojectname oldProjectName	 m  ��

 �  . h�k  �j   l � r  � b  �� o  ���h�h  0 newprojectname newProjectName m  �� �  . h n       1  �g
�g 
pnam n  � 4  ��f
�f 
docf o  �e�e 0 currentfile currentFile o  ���d�d 0 	thefolder 	theFolder    should only happen once		    � 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	  = 
 o  
�c�c 0 currentfile currentFile l �b�a b   !  o  �`�`  0 oldprojectname oldProjectName! m  "" �##  _ P r e f i x . h�b  �a   $�_$ l "%&'% r  "()( b  *+* o  �^�^  0 newprojectname newProjectName+ m  ,, �--  _ P r e f i x . h) n      ./. 1  !�]
�] 
pnam/ n  010 4  �\2
�\ 
docf2 o  �[�[ 0 currentfile currentFile1 o  �Z�Z 0 	thefolder 	theFolder&   should only happen once	   ' �33 2   s h o u l d   o n l y   h a p p e n   o n c e 	�_  �m  �n  � 454 =  )0676 o  )*�Y�Y 0 currentfile currentFile7 b  */898 o  *+�X�X  0 oldprojectname oldProjectName9 m  +.:: �;;  . n i b5 <=< r  3A>?> b  38@A@ o  34�W�W  0 newprojectname newProjectNameA m  47BB �CC  . n i b? n      DED 1  >@�V
�V 
pnamE n  8>FGF 4  9>�UH
�U 
docfH o  <=�T�T 0 currentfile currentFileG o  89�S�S 0 	thefolder 	theFolder= IJI =  DKKLK o  DE�R�R 0 currentfile currentFileL b  EJMNM o  EF�Q�Q  0 oldprojectname oldProjectNameN m  FIOO �PP  . x i bJ QRQ k  NjSS TUT n N[VWV I  O[�PX�O�P &0 replacetextinfile replaceTextInFileX YZY c  OR[\[ o  OP�N�N 0 	thefolder 	theFolder\ m  PQ�M
�M 
ctxtZ ]^] o  RS�L�L 0 currentfile currentFile^ _`_ o  ST�K�K  0 oldprojectname oldProjectName` aba o  TU�J�J  0 newprojectname newProjectNameb cdc o  UV�I�I 0 
old_prefix  d e�He o  VW�G�G 0 
new_prefix  �H  �O  W  f  NOU f�Ff r  \jghg b  \aiji o  \]�E�E  0 newprojectname newProjectNamej m  ]`kk �ll  . x i bh n      mnm 1  gi�D
�D 
pnamn n  agopo 4  bg�Cq
�C 
docfq o  ef�B�B 0 currentfile currentFilep o  ab�A�A 0 	thefolder 	theFolder�F  R rsr D  mrtut o  mn�@�@ 0 currentfile currentFileu m  nqvv �ww  . p l i s ts x�?x k  uyy z{z r  u~|}| m  ux~~ �  . p l i s t} o      �>�> 0 
filesuffix 
fileSuffix{ ��� n ���� I  ���=��<�= &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ���;�; 0 	thefolder 	theFolder� m  ���:
�: 
ctxt� ��� o  ���9�9 0 currentfile currentFile� ��� o  ���8�8  0 oldprojectname oldProjectName� ��� o  ���7�7  0 newprojectname newProjectName� ��� o  ���6�6 0 
old_prefix  � ��5� o  ���4�4 0 
new_prefix  �5  �<  �  f  �� ��� r  ����� I ���3��2
�3 .sysoctonshor       TEXT� l ����1�0� n  ����� 4 ���/�
�/ 
cobj� m  ���.�. � o  ���-�-  0 oldprojectname oldProjectName�1  �0  �2  � o      �,�, 0 testchar testChar� ��� Z  �����+�*� F  ����� @  ����� o  ���)�) 0 testchar testChar� m  ���(�( A� B  ����� o  ���'�' 0 testchar testChar� m  ���&�& Z� l ������ k  ���� ��� r  ����� m  ���� ���  � o      �%�% 
0 locase  � ��� Y  ����$���#� r  ����� b  ����� o  ���"�" 
0 locase  � l ����!� � n  ����� 4  ����
� 
cobj� o  ���� 0 n  � o  ����  0 oldprojectname oldProjectName�!  �   � o      �� 
0 locase  �$ 0 n  � m  ���� � l ������ I �����
� .corecnte****       ****� o  ����  0 oldprojectname oldProjectName�  �  �  �#  � ��� r  ����� b  ����� l ������ I �����
� .sysontocTEXT       shor� l ������ [  ����� o  ���� 0 testchar testChar� m  ����  �  �  �  �  �  � o  ���� 
0 locase  � o      �� 
0 locase  �  �   is it uppercase ?   � ��� $   i s   i t   u p p e r c a s e   ?�+  �*  � ��� l ������ n ����� I  ���
��	�
 &0 simplereplacetext simpleReplaceText� ��� o  ���� 0 currentfile currentFile� ��� o  ���� 
0 locase  � ��� o  ����  0 newprojectname newProjectName�  �	  �  f  ��� 7 1 catch any lowercase instances of project name 		   � ��� b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 	� ��� l ������  � ; 5 rename only .plist files containing the projectname    � ��� j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  � ��� r  ���� l ������ I ��� ���  0 searchreplace searchReplace�  f  ��� ����
�� 
into� o  ������ 0 currentfile currentFile� ����
�� 
at  � o  ������  0 oldprojectname oldProjectName� ������� 0 replacestring replaceString� o  ������  0 newprojectname newProjectName��  �  �  � n      ��� 1   ��
�� 
pnam� n  � ��� 4  � ���
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	thefolder 	theFolder�  �?  ��  � F @ project files that don't include prefix also need to be updated   � ��� �   p r o j e c t   f i l e s   t h a t   d o n ' t   i n c l u d e   p r e f i x   a l s o   n e e d   t o   b e   u p d a t e d�v  �   Do all files   � ���    D o   a l l   f i l e s�� 0 n   m   ` a���� � o   a b���� 0 numfiles numFiles��  } ���� l ��������  ��  ��  ��  O m   7 8���                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  ��   � ��� l     ��������  ��  ��  � ��� l     ������  � J D subroutine to replace old file names and prefixes with the new ones   � ��� �   s u b r o u t i n e   t o   r e p l a c e   o l d   f i l e   n a m e s   a n d   p r e f i x e s   w i t h   t h e   n e w   o n e s� ��� i   ��� I      ������� &0 replacetextinfile replaceTextInFile� ��� o      ���� 0 	thefolder 	theFolder� ��� o      ���� 0 thefile theFile�    o      ���� 0 oldtext1    o      ���� 0 newtext1    o      ���� 0 oldtext2   �� o      ���� 0 newtext2  ��  ��  � k    P 	 r     

 m      �  m y t e m p . h o      ���� 0 tempfile tempFile	  r     c    	 n     1    ��
�� 
psxp o    ���� 0 	thefolder 	theFolder m    ��
�� 
TEXT o      ���� 0 myfolderpath myFolderPath  l   ����     Create a script for sed    � 0   C r e a t e   a   s c r i p t   f o r   s e d  r     b      o    ���� 0 myfolderpath myFolderPath  o    ���� &0 replacescriptname replaceScriptName o      ���� 0 filename fileName !"! r    "#$# I    ��%&
�� .rdwropenshor       file% 4    ��'
�� 
psxf' o    ���� 0 filename fileName& ��(��
�� 
perm( m    ��
�� boovtrue��  $ o      ���� 0 fileid fileID" )*) I  # Z��+,
�� .rdwrwritnull���     ****+ b   # R-.- b   # N/0/ b   # H121 b   # F343 b   # D565 b   # B787 b   # @9:9 b   # >;<; b   # 8=>= b   # 6?@? b   # 4ABA b   # 2CDC b   # ,EFE b   # *GHG b   # (IJI b   # &KLK m   # $MM �NN $ s / \ ( [ ^ a - j l - z A - Z ] \ )L o   $ %���� 0 oldtext2  J m   & 'OO �PP  / \ 1H o   ( )���� 0 newtext2  F m   * +QQ �RR  / gD l  , 1S����S I  , 1��T��
�� .sysontocTEXT       shorT m   , -���� 
��  ��  ��  B m   2 3UU �VV  / ^@ o   4 5���� 0 oldtext2  > m   6 7WW �XX  / {  < l  8 =Y����Y I  8 =��Z��
�� .sysontocTEXT       shorZ m   8 9���� 
��  ��  ��  : m   > ?[[ �\\  s /8 o   @ A���� 0 oldtext2  6 m   B C]] �^^  /4 o   D E���� 0 newtext2  2 m   F G__ �``  / 10 l  H Ma����a I  H M��b��
�� .sysontocTEXT       shorb m   H I���� 
��  ��  ��  . m   N Qcc �dd  }, ��e��
�� 
refne o   U V���� 0 fileid fileID��  * fgf I  [ `��h��
�� .rdwrclosnull���     ****h o   [ \���� 0 fileid fileID��  g iji l  a a��kl��  k  end if   l �mm  e n d   i fj non r   a hpqp c   a frsr n   a dtut 1   b d��
�� 
psxpu o   a b���� 0 	thefolder 	theFolders m   d e��
�� 
TEXTq o      ���� 0 	shellpath 	ShellPatho vwv l  i �xyzx r   i �{|{ l  i �}����} I  i �����~�� 0 searchreplace searchReplace��  ~ ���
�� 
into o   m n���� 0 	shellpath 	ShellPath� ����
�� 
at  � l  q t������ m   q t�� ���   ��  ��  � ������� 0 replacestring replaceString� m   w z�� ���  \ %��  ��  ��  | o      ���� 0 	shellpath 	ShellPathy H B uses global variable to overcome POSIX issue with spaces in names   z ��� �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e sw ��� r   � ���� l  � ������� I  � �������� 0 searchreplace searchReplace��  � ����
�� 
into� o   � ����� 0 	shellpath 	ShellPath� ����
�� 
at  � m   � ��� ���  %� ������� 0 replacestring replaceString� m   � ��� ���   ��  ��  ��  � o      ���� 0 	shellpath 	ShellPath� ��� l  � �������  � 7 1 replace occurences of oldProject with newProject   � ��� b   r e p l a c e   o c c u r e n c e s   o f   o l d P r o j e c t   w i t h   n e w P r o j e c t� ��� r   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� m   � ��� ��� 
 c a t    � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� m   � ��� ���    ;  � m   � ��� ���      >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    ;  � m   � ��� ���    s e d   - e   ' s /� o   � ����� 0 oldtext1  � m   � ��� ���  /� o   � ����� 0 newtext1  � m   � ��� ���  / g '  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� m   � ��� ���    >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    ;  � m   � ��� ���    >� o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� o      ���� 0 cmd  � ��� I  � ������
�� .sysoexecTEXT���     TEXT� o   � ����� 0 cmd  ��  � ��� l  � �������  � 5 / replace occurences of oldPrefix with newPrefix   � ��� ^   r e p l a c e   o c c u r e n c e s   o f   o l d P r e f i x   w i t h   n e w P r e f i x� ��� r   �6��� b   �4��� b   �2��� b   �0��� b   �,��� b   �(��� b   �&��� b   �$   b   �  b   � b   � b   �	 b   �

 b   � b   � b   � b   � b   � b   �  b   � � b   � � b   � � b   � � b   � � !  m   � �"" �##  c a t  ! o   � ����� 0 	shellpath 	ShellPath o   � ����� 0 thefile theFile m   � �$$ �%%    >   o   � ����� 0 	shellpath 	ShellPath o   � ����� 0 tempfile tempFile m   � �&& �''    ;   m   (( �))    >   o  ���� 0 	shellpath 	ShellPath o  ���� 0 thefile theFile m  ** �++    ;   m  ,, �--    s e d   - f   o  ���� 0 	shellpath 	ShellPath	 o  ���� &0 replacescriptname replaceScriptName m  .. �//    o  �� 0 	shellpath 	ShellPath o  �~�~ 0 tempfile tempFile m   #00 �11    >  � o  $%�}�} 0 	shellpath 	ShellPath� o  &'�|�| 0 thefile theFile� m  (+22 �33    ;  � m  ,/44 �55    r m   - f  � o  01�{�{ 0 	shellpath 	ShellPath� o  23�z�z 0 tempfile tempFile� o      �y�y 0 cmd  � 676 I 7<�x8�w
�x .sysoexecTEXT���     TEXT8 o  78�v�v 0 cmd  �w  7 9:9 l ==�u;<�u  ;   delete the temp file   < �== *   d e l e t e   t h e   t e m p   f i l e: >?> l =J@AB@ r  =JCDC b  =HEFE b  =BGHG m  =@II �JJ  r m  H o  @A�t�t 0 	shellpath 	ShellPathF o  BG�s�s &0 replacescriptname replaceScriptNameD o      �r�r 0 cmd  A 5 / remove sed script file from new project folder   B �KK ^   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e r? L�qL I KP�pM�o
�p .sysoexecTEXT���     TEXTM o  KL�n�n 0 cmd  �o  �q  � NON l     �m�l�k�m  �l  �k  O PQP l     �jRS�j  R U O simple form of replaceTextinFile subroutine to handle plist and project files    S �TT �   s i m p l e   f o r m   o f   r e p l a c e T e x t i n F i l e   s u b r o u t i n e   t o   h a n d l e   p l i s t   a n d   p r o j e c t   f i l e s  Q UVU i    WXW I      �iY�h�i &0 simplereplacetext simpleReplaceTextY Z[Z o      �g�g 0 thefile theFile[ \]\ o      �f�f 0 oldtext  ] ^�e^ o      �d�d 0 newtext newText�e  �h  X k     ___ `a` l    bcdb r     efe c     	ghg b     iji m     kk �ll  t e m pj o    �c�c 0 
filesuffix 
fileSuffixh m    �b
�b 
TEXTf o      �a�a 0 tempfile tempFilec %  use global variable fileSuffix   d �mm >   u s e   g l o b a l   v a r i a b l e   f i l e S u f f i xa non l   pqrp r    sts l   u�`�_u I   �^�]v�^ 0 searchreplace searchReplace�]  v �\wx
�\ 
intow o    �[�[ 0 mypath myPathx �Zyz
�Z 
at  y l   {�Y�X{ m    || �}}   �Y  �X  z �W~�V�W 0 replacestring replaceString~ m     ���  \ %�V  �`  �_  t o      �U�U 0 	shellpath 	ShellPathq H B uses global variable to overcome POSIX issue with spaces in names   r ��� �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e so ��� r    +��� l   )��T�S� I   )�R�Q��R 0 searchreplace searchReplace�Q  � �P��
�P 
into� o     !�O�O 0 	shellpath 	ShellPath� �N��
�N 
at  � m   " #�� ���  %� �M��L�M 0 replacestring replaceString� m   $ %�� ���   �L  �T  �S  � o      �K�K 0 	shellpath 	ShellPath� ��� l  , Y���� r   , Y��� b   , W��� b   , U��� b   , Q��� b   , O��� b   , K��� b   , I��� b   , E��� b   , C��� b   , ?��� b   , =��� b   , ;��� b   , 9��� b   , 7��� b   , 5��� b   , 3��� b   , 1��� b   , /��� m   , -�� ���  b a s h ;   c d  � o   - .�J�J 0 	shellpath 	ShellPath� m   / 0�� ���  ;   c a t  � o   1 2�I�I 0 thefile theFile� m   3 4�� ���    >  � o   5 6�H�H 0 tempfile tempFile� m   7 8�� ���  ;   >� o   9 :�G�G 0 thefile theFile� m   ; <�� ���  ;   s e d   - e   ' s /� o   = >�F�F 0 oldtext  � m   ? B�� ���  /� o   C D�E�E 0 newtext newText� m   E H�� ���  / g '  � o   I J�D�D 0 tempfile tempFile� m   K N�� ���    >  � o   O P�C�C 0 thefile theFile� m   Q T�� ���  ;   r m   - f  � o   U V�B�B 0 tempfile tempFile� o      �A�A 0 cmd  �   and clean up!   � ���    a n d   c l e a n   u p !� ��@� I  Z _�?��>
�? .sysoexecTEXT���     TEXT� o   Z [�=�= 0 cmd  �>  �@  V ��� l     �<�;�:�<  �;  �:  � ��� l     �9���9  � j d universal search and replace subroutine -- operates strictly in AppleScript on a string or document   � ��� �   u n i v e r s a l   s e a r c h   a n d   r e p l a c e   s u b r o u t i n e   - -   o p e r a t e s   s t r i c t l y   i n   A p p l e S c r i p t   o n   a   s t r i n g   o r   d o c u m e n t� ��� i   ! $��� I      �8�7��8 0 searchreplace searchReplace�7  � �6��
�6 
into� o      �5�5 0 
mainstring 
mainString� �4��
�4 
at  � o      �3�3 0 searchstring searchString� �2��1�2 0 replacestring replaceString� o      �0�0 0 replacestring replaceString�1  � k     S�� ��� V     P��� l   K���� k    K�� ��� l   �/���/  � v p we use offset command here to derive the position within the document where the search string first appears       � ��� �   w e   u s e   o f f s e t   c o m m a n d   h e r e   t o   d e r i v e   t h e   p o s i t i o n   w i t h i n   t h e   d o c u m e n t   w h e r e   t h e   s e a r c h   s t r i n g   f i r s t   a p p e a r s        � ��� r    ��� I   �.�-�
�. .sysooffslong    ��� null�-  � �,��
�, 
psof� o   
 �+�+ 0 searchstring searchString� �*��)
�* 
psin� o    �(�( 0 
mainstring 
mainString�)  � o      �'�' 0 foundoffset foundOffset� ��� l   �&���&  � � � begin assembling remade string by getting all text up to the search location, minus the first character of the search string      � ���    b e g i n   a s s e m b l i n g   r e m a d e   s t r i n g   b y   g e t t i n g   a l l   t e x t   u p   t o   t h e   s e a r c h   l o c a t i o n ,   m i n u s   t h e   f i r s t   c h a r a c t e r   o f   t h e   s e a r c h   s t r i n g      � ��� Z    /���%�� =      o    �$�$ 0 foundoffset foundOffset m    �#�# � l    r     m     �   o      �"�" 0 stringstart stringStart \ V search string starts at beginning, most likely to occur when searching a small string    �		 �   s e a r c h   s t r i n g   s t a r t s   a t   b e g i n n i n g ,   m o s t   l i k e l y   t o   o c c u r   w h e n   s e a r c h i n g   a   s m a l l   s t r i n g�%  � r     /

 n     - 7  ! -�!
�! 
ctxt m   % '� �   l  ( ,�� \   ( , o   ) *�� 0 foundoffset foundOffset m   * +�� �  �   o     !�� 0 
mainstring 
mainString o      �� 0 stringstart stringStart�  l  0 0��   / ) get the end part of the remade string       � R   g e t   t h e   e n d   p a r t   o f   t h e   r e m a d e   s t r i n g        r   0 C n   0 A 7  1 A�
� 
ctxt l  5 = ��  [   5 =!"! o   6 7�� 0 foundoffset foundOffset" l  7 <#��# I  7 <�$�
� .corecnte****       ****$ o   7 8�� 0 searchstring searchString�  �  �  �  �   m   > @���� o   0 1�� 0 
mainstring 
mainString o      �� 0 	stringend 	stringEnd %&% l  D D�'(�  ' C = remake mainString to start, replace string and end string      ( �)) z   r e m a k e   m a i n S t r i n g   t o   s t a r t ,   r e p l a c e   s t r i n g   a n d   e n d   s t r i n g      & *�* r   D K+,+ b   D I-.- b   D G/0/ o   D E�
�
 0 stringstart stringStart0 o   E F�	�	 0 replacestring replaceString. o   G H�� 0 	stringend 	stringEnd, o      �� 0 
mainstring 
mainString�  � 6 0 will not do anything if search string not found   � �11 `   w i l l   n o t   d o   a n y t h i n g   i f   s e a r c h   s t r i n g   n o t   f o u n d� E    232 o    �� 0 
mainstring 
mainString3 o    �� 0 searchstring searchString� 4�4 l  Q S5675 L   Q S88 o   Q R�� 0 
mainstring 
mainString6 "  ship it back to the caller    7 �99 8   s h i p   i t   b a c k   t o   t h e   c a l l e r  �  � :;: l     ��� �  �  �   ; <=< i  % (>?> I      ��@���� 0 upcase upCase@ A��A o      ���� 0 astring aString��  ��  ? k     PBB CDC r     EFE m     GG �HH  F o      ���� 
0 buffer  D IJI Y    MK��LM��K k    HNN OPO r    QRQ l   S����S I   ��T��
�� .sysoctonshor       TEXTT n    UVU 4    ��W
�� 
cobjW o    ���� 0 i  V o    ���� 0 astring aString��  ��  ��  R o      ���� 0 testchar testCharP XYX l   ��������  ��  ��  Y Z[Z Z    F\]��^\ F    (_`_ @     aba o    ���� 0 testchar testCharb m    ���� a` B   # &cdc o   # $���� 0 testchar testChard m   $ %���� z] k   + 8ee fgf l  + +��hi��  h D > if lowercase ascii character then change to uppercase version   i �jj |   i f   l o w e r c a s e   a s c i i   c h a r a c t e r   t h e n   c h a n g e   t o   u p p e r c a s e   v e r s i o ng klk r   + 6mnm b   + 4opo o   + ,���� 
0 buffer  p l  , 3q����q I  , 3��r��
�� .sysontocTEXT       shorr l  , /s����s \   , /tut o   , -���� 0 testchar testCharu m   - .����  ��  ��  ��  ��  ��  n o      ���� 
0 buffer  l v��v l  7 7��������  ��  ��  ��  ��  ^ k   ; Fww xyx l  ; ;��z{��  z   do not chage character   { �|| .   d o   n o t   c h a g e   c h a r a c t e ry }~} r   ; D� b   ; B��� o   ; <���� 
0 buffer  � l  < A������ I  < A�����
�� .sysontocTEXT       shor� l  < =������ o   < =���� 0 testchar testChar��  ��  ��  ��  ��  � o      ���� 
0 buffer  ~ ���� l  E E��������  ��  ��  ��  [ ���� l  G G��������  ��  ��  ��  �� 0 i  L m    ���� M I   �����
�� .corecnte****       ****� o    	���� 0 astring aString��  ��  J ��� l  N N��������  ��  ��  � ���� L   N P�� o   N O���� 
0 buffer  ��  = ��� l     ��������  ��  ��  � ��� l     ������  �   T.J. Mahaffey | 9.9.2004   � ��� 2   T . J .   M a h a f f e y   |   9 . 9 . 2 0 0 4� ��� l     ������  �   1951FDG | 8.4.2011   � ��� &   1 9 5 1 F D G   |   8 . 4 . 2 0 1 1� ��� l     ������  � � � The code contained herein is free. Re-use at will, but please include a web bookmark or weblocation file to my website if you do.   � ���   T h e   c o d e   c o n t a i n e d   h e r e i n   i s   f r e e .   R e - u s e   a t   w i l l ,   b u t   p l e a s e   i n c l u d e   a   w e b   b o o k m a r k   o r   w e b l o c a t i o n   f i l e   t o   m y   w e b s i t e   i f   y o u   d o .� ��� l     ������  � ; 5 Or simply some kind of acknowledgement in your code.   � ��� j   O r   s i m p l y   s o m e   k i n d   o f   a c k n o w l e d g e m e n t   i n   y o u r   c o d e .� ��� l     ��������  ��  ��  � ��� l     ������  � ' ! Prepare progress bar subroutine.   � ��� B   P r e p a r e   p r o g r e s s   b a r   s u b r o u t i n e .� ��� i   ) ,��� I      �������  0 prepareprogbar prepareProgBar� ��� o      ���� 0 somemaxcount someMaxCount� ���� o      ���� 0 
windowname 
windowName��  ��  � O     a��� k    `�� ��� r    ��� J    	�� ��� m    ����   ��� ��� m    ����   ��� ���� m    ����   ����  � n      ��� 1    ��
�� 
bacC� 4   	 ���
�� 
cwin� o    ���� 0 
windowname 
windowName� ��� r    ��� m    ��
�� boovtrue� n      ��� 1    ��
�� 
hasS� 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName� ��� r    -��� n    &��� 4   # &���
�� 
cobj� m   $ %���� � J    #�� ��� m    ����  � ��� m    ���� � ��� m    ���� � ��� m    ���� � ��� m    ���� � ��� m     ���� e� ���� m     !�������  � n      ��� 1   * ,��
�� 
levV� 4   & *���
�� 
cwin� o   ( )���� 0 
windowname 
windowName� ��� r   . 6��� m   . /�� ���  � n      ��� 1   3 5��
�� 
titl� 4   / 3���
�� 
cwin� o   1 2���� 0 
windowname 
windowName� ��� r   7 D��� m   7 8����  � n      ��� 1   ? C��
�� 
conT� n   8 ?��� 4   < ?���
�� 
proI� m   = >���� � 4   8 <���
�� 
cwin� o   : ;���� 0 
windowname 
windowName� ��� r   E R��� m   E F����  � n      ��� 1   M Q��
�� 
minW� n   F M��� 4   J M���
�� 
proI� m   K L���� � 4   F J���
�� 
cwin� o   H I���� 0 
windowname 
windowName� ���� r   S `� � o   S T���� 0 somemaxcount someMaxCount  n       1   [ _��
�� 
maxV n   T [ 4   X [��
�� 
proI m   Y Z����  4   T X��
�� 
cwin o   V W���� 0 
windowname 
windowName��  � m     �                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  � 	 l     ����~��  �  �~  	 

 l     �}�}   ) # Increment progress bar subroutine.    � F   I n c r e m e n t   p r o g r e s s   b a r   s u b r o u t i n e .  i   - 0 I      �|�{�| $0 incrementprogbar incrementProgBar  o      �z�z 0 
itemnumber 
itemNumber  o      �y�y 0 somemaxcount someMaxCount �x o      �w�w 0 
windowname 
windowName�x  �{   O     & k    %  r     b     !  b    "#" b    $%$ b    	&'& b    ()( m    ** �++  P r o c e s s i n g  ) o    �v�v 0 
itemnumber 
itemNumber' m    ,, �--    o f  % o   	 
�u�u 0 somemaxcount someMaxCount# m    .. �//    -  ! l   0�t�s0 n    121 4    �r3
�r 
cobj3 o    �q�q 0 
itemnumber 
itemNumber2 o    �p�p 0 filelist fileList�t  �s   n      454 1    �o
�o 
titl5 4    �n6
�n 
cwin6 o    �m�m 0 
windowname 
windowName 7�l7 r    %898 o    �k�k 0 
itemnumber 
itemNumber9 n      :;: 1   " $�j
�j 
conT; n    "<=< 4    "�i>
�i 
proI> m     !�h�h = 4    �g?
�g 
cwin? o    �f�f 0 
windowname 
windowName�l   m     @@�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��   ABA l     �e�d�c�e  �d  �c  B CDC l     �bEF�b  E %  Fade in a progress bar window.   F �GG >   F a d e   i n   a   p r o g r e s s   b a r   w i n d o w .D HIH i   1 4JKJ I      �aL�`�a 0 fadeinprogbar fadeinProgBarL M�_M o      �^�^ 0 
windowname 
windowName�_  �`  K O     ONON k    NPP QRQ I   �]S�\
�] .appScentnull���    obj S 4    �[T
�[ 
cwinT o    �Z�Z 0 
windowname 
windowName�\  R UVU r    WXW m    �Y�Y  X n      YZY 1    �X
�X 
alpVZ 4    �W[
�W 
cwin[ o    �V�V 0 
windowname 
windowNameV \]\ r    ^_^ m    �U
�U boovtrue_ n      `a` 1    �T
�T 
pvisa 4    �Sb
�S 
cwinb o    �R�R 0 
windowname 
windowName] cdc r    "efe m     gg ?�������f o      �Q�Q 0 	fadevalue 	fadeValued hih Y   # @j�Pkl�Oj k   - ;mm non r   - 5pqp o   - .�N�N 0 	fadevalue 	fadeValueq n      rsr 1   2 4�M
�M 
alpVs 4   . 2�Lt
�L 
cwint o   0 1�K�K 0 
windowname 
windowNameo u�Ju r   6 ;vwv [   6 9xyx o   6 7�I�I 0 	fadevalue 	fadeValuey m   7 8zz ?�������w o      �H�H 0 	fadevalue 	fadeValue�J  �P 0 i  k m   & '�G�G  l m   ' (�F�F 	�O  i {�E{ I  A N�D|}
�D .coVSstaAnull���    obj | n   A H~~ 4   E H�C�
�C 
proI� m   F G�B�B  4   A E�A�
�A 
cwin� o   C D�@�@ 0 
windowname 
windowName} �?��>
�? 
usTA� m   I J�=
�= boovtrue�>  �E  O m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  I ��� l     �<�;�:�<  �;  �:  � ��� l     �9���9  � &   Fade out a progress bar window.   � ��� @   F a d e   o u t   a   p r o g r e s s   b a r   w i n d o w .� ��� i   5 8��� I      �8��7�8  0 fadeoutprogbar fadeoutProgBar� ��6� o      �5�5 0 
windowname 
windowName�6  �7  � O     =��� k    <�� ��� I   �4��
�4 .coVSstoTnull���    obj � n    ��� 4    �3�
�3 
proI� m   	 
�2�2 � 4    �1�
�1 
cwin� o    �0�0 0 
windowname 
windowName� �/��.
�/ 
usTA� m    �-
�- boovtrue�.  � ��� r    ��� m    �� ?�������� o      �,�, 0 	fadevalue 	fadeValue� ��� Y    3��+���*� k     .�� ��� r     (��� o     !�)�) 0 	fadevalue 	fadeValue� n      ��� 1   % '�(
�( 
alpV� 4   ! %�'�
�' 
cwin� o   # $�&�& 0 
windowname 
windowName� ��%� r   ) .��� \   ) ,��� o   ) *�$�$ 0 	fadevalue 	fadeValue� m   * +�� ?�������� o      �#�# 0 	fadevalue 	fadeValue�%  �+ 0 i  � m    �"�" � m    �!�! 	�*  � �� � r   4 <��� m   4 5�
� boovfals� n      ��� 1   9 ;�
� 
pvis� 4   5 9��
� 
cwin� o   7 8�� 0 
windowname 
windowName�   � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  � ��� l     ����  �  �  � ��� l     ����  �    Show progress bar window.   � ��� 4   S h o w   p r o g r e s s   b a r   w i n d o w .� ��� i   9 <��� I      ���� 0 showprogbar showProgBar� ��� o      �� 0 
windowname 
windowName�  �  � O     $��� k    #�� ��� I   ���
� .appScentnull���    obj � 4    ��
� 
cwin� o    �� 0 
windowname 
windowName�  � ��� r    ��� m    �
� boovtrue� n      ��� 1    �
� 
pvis� 4    ��
� 
cwin� o    �� 0 
windowname 
windowName� ��� I   #�
��
�
 .coVSstaAnull���    obj � n    ��� 4    �	�
�	 
proI� m    �� � 4    ��
� 
cwin� o    �� 0 
windowname 
windowName� ���
� 
usTA� m    �
� boovtrue�  �  � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  � ��� l     ��� �  �  �   � ��� l     ������  �    Hide progress bar window.   � ��� 4   H i d e   p r o g r e s s   b a r   w i n d o w .� ��� i   = @��� I      ������� 0 hideprogbar hideProgBar� ���� o      ���� 0 
windowname 
windowName��  ��  � O     ��� k    �� ��� I   ����
�� .coVSstoTnull���    obj � n    ��� 4    ���
�� 
proI� m   	 
���� � 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName� �����
�� 
usTA� m    ��
�� boovtrue��  � ���� r    ��� m    ��
�� boovfals� n      ��� 1    ��
�� 
pvis� 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName��  � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  � 	 		  l     ��������  ��  ��  	 			 l     ��		��  	 7 1 Enable 'barber pole' behavior of a progress bar.   	 �		 b   E n a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .	 			 i   A D			
		 I      ��	���� 0 
barberpole 
barberPole	 	��	 o      ���� 0 
windowname 
windowName��  ��  	
 O     			 r    			 m    ��
�� boovtrue	 n      			 1    ��
�� 
indR	 n    			 4   	 ��	
�� 
proI	 m   
 ���� 	 4    	��	
�� 
cwin	 o    ���� 0 
windowname 
windowName	 m     		�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	 			 l     ��������  ��  ��  	 			 l     ��		��  	 8 2 Disable 'barber pole' behavior of a progress bar.   	 �		 d   D i s a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .	 		 	 i   E H	!	"	! I      ��	#����  0 killbarberpole killBarberPole	# 	$��	$ o      ���� 0 
windowname 
windowName��  ��  	" O     	%	&	% r    	'	(	' m    ��
�� boovfals	( n      	)	*	) 1    ��
�� 
indR	* n    	+	,	+ 4   	 ��	-
�� 
proI	- m   
 ���� 	, 4    	��	.
�� 
cwin	. o    ���� 0 
windowname 
windowName	& m     	/	/�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	  	0	1	0 l     ��������  ��  ��  	1 	2	3	2 l     ��	4	5��  	4   Launch ProgBar.   	5 �	6	6     L a u n c h   P r o g B a r .	3 	7	8	7 i   I L	9	:	9 I      �������� 0 startprogbar startProgBar��  ��  	: O     
	;	<	; I   	������
�� .ascrnoop****      � ****��  ��  	< m     	=	=�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	8 	>	?	> l     ��������  ��  ��  	? 	@	A	@ l     ��	B	C��  	B   Quit ProgBar.   	C �	D	D    Q u i t   P r o g B a r .	A 	E	F	E i   M P	G	H	G I      �������� 0 stopprogbar stopProgBar��  ��  	H O     
	I	J	I I   	������
�� .aevtquitnull��� ��� null��  ��  	J m     	K	K�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	F 	L	M	L l     ��������  ��  ��  	M 	N	O	N l     ��	P	Q��  	P  ////////////  User input   	Q �	R	R 0 / / / / / / / / / / / /     U s e r   i n p u t	O 	S	T	S l     ��������  ��  ��  	T 	U	V	U l   #	W	X	Y	W r    #	Z	[	Z m    	\	\ �	]	]  R E S U B M I T	[ o      ���� 0 buttonpressed buttonPressed	X   at least try one time   	Y �	^	^ ,   a t   l e a s t   t r y   o n e   t i m e	V 	_	`	_ l  $�	a����	a V   $�	b	c	b k   0�	d	d 	e	f	e l  0 0��	g	h��  	g + %  User chooses project folder to copy   	h �	i	i J     U s e r   c h o o s e s   p r o j e c t   f o l d e r   t o   c o p y	f 	j	k	j r   0 C	l	m	l c   0 ?	n	o	n l  0 ;	p����	p I  0 ;����	q
�� .sysostflalis    ��� null��  	q ��	r��
�� 
prmp	r m   4 7	s	s �	t	t h T o   d u p l i c a t e :   c h o o s e   P l u g i n   p r o j e c t   t o   u s e   a s   s o u r c e��  ��  ��  	o m   ; >��
�� 
alis	m o      ���� 0 	thefolder 	theFolder	k 	u	v	u r   D U	w	x	w n   D O	y	z	y 1   K O��
�� 
pnam	z l  D K	{����	{ I  D K��	|��
�� .sysonfo4asfe        file	| o   D G���� 0 	thefolder 	theFolder��  ��  ��  	x o      ����  0 oldprojectname oldProjectName	v 	}	~	} l  V V��������  ��  ��  	~ 		�	 l  V V��	�	���  	� s m this extracts the path to folder in which the duplicated project folder resides and gives it the name myHome   	� �	�	� �   t h i s   e x t r a c t s   t h e   p a t h   t o   f o l d e r   i n   w h i c h   t h e   d u p l i c a t e d   p r o j e c t   f o l d e r   r e s i d e s   a n d   g i v e s   i t   t h e   n a m e   m y H o m e	� 	�	�	� l  V V��	�	���  	� 1 + POSIX format because used by shell scripts   	� �	�	� V   P O S I X   f o r m a t   b e c a u s e   u s e d   b y   s h e l l   s c r i p t s	� 	�	�	� Q   V �	�	�	�	� k   Y �	�	� 	�	�	� r   Y d	�	�	� n  Y `	�	�	� 1   \ `��
�� 
txdl	� 1   Y \��
�� 
ascr	� o      ���� 0 olddelimiter oldDelimiter	� 	�	�	� r   e t	�	�	� c   e p	�	�	� n   e l	�	�	� 1   h l��
�� 
psxp	� o   e h���� 0 	thefolder 	theFolder	� m   l o��
�� 
TEXT	� o      ���� 0 myhome myHome	� 	�	�	� r   u �	�	�	� m   u x	�	� �	�	�  /	� n     	�	�	� 1   { ��
�� 
txdl	� 1   x {��
�� 
ascr	� 	�	�	� r   � �	�	�	� I  � ���	���
�� .corecnte****       ****	� l  � �	�����	� n   � �	�	�	� 2   � ���
�� 
citm	� o   � ����� 0 myhome myHome��  ��  ��  	� o      ���� 0 totl  	� 	�	�	� l  � �	�	�	�	� r   � �	�	�	� \   � �	�	�	� o   � ����� 0 totl  	� m   � ����� 	� o      ���� 
0 ending  	� + % remove current folder name from path   	� �	�	� J   r e m o v e   c u r r e n t   f o l d e r   n a m e   f r o m   p a t h	� 	�	�	� r   � �	�	�	� b   � �	�	�	� l  � �	�����	� c   � �	�	�	� n   � �	�	�	� 7  � ���	�	�
�� 
citm	� m   � ����� 	� o   � ����� 
0 ending  	� o   � ����� 0 myhome myHome	� m   � ���
�� 
TEXT��  ��  	� m   � �	�	� �	�	�  /	� o      ���� 0 myhome myHome	� 	���	� r   � �	�	�	� o   � ����� 0 olddelimiter oldDelimiter	� n     	�	�	� 1   � ���
�� 
txdl	� 1   � ���
�� 
ascr��  	� R      �	��~
� .ascrerr ****      � ****	� m      	�	� �	�	� ~ e r r o r   o c c u r r e d   a t t e m p t i n g   t o   e x t r a c t   p a t h   t o   n e w   p r o j e c t   f o l d e r�~  	� r   � �	�	�	� o   � ��}�} 0 olddelimiter oldDelimiter	� n     	�	�	� 1   � ��|
�| 
txdl	� 1   � ��{
�{ 
ascr	� 	�	�	� l  � ��z�y�x�z  �y  �x  	� 	�	�	� l  � ��w	�	��w  	� ? 9 User chooses the name they wish to give the project copy   	� �	�	� r   U s e r   c h o o s e s   t h e   n a m e   t h e y   w i s h   t o   g i v e   t h e   p r o j e c t   c o p y	� 	�	�	� I  � ��v	�	�
�v .sysodlogaskr        TEXT	� m   � �	�	� �	�	� & N a m e   o f   n e w   p l u g i n ?	� �u	�	�
�u 
dtxt	� m   � �	�	� �	�	�  n e w P l u g i n	� �t	�	�
�t 
btns	� J   � �	�	� 	��s	� m   � �	�	� �	�	�    O K�s  	� �r	��q
�r 
dflt	� m   � ��p�p �q  	� 	�	�	� s   �	�	�	� c   � �	�	�	� l  � �	��o�n	� 1   � ��m
�m 
rslt�o  �n  	� m   � ��l
�l 
list	� J      	�	� 	�	�	� o      �k�k 0 button_pressed  	� 	��j	� o      �i�i 0 text_returned  �j  	� 	�	�	� r   	�	�	� c  	�	�	� o  �h�h 0 text_returned  	� m  �g
�g 
TEXT	� o      �f�f  0 newprojectname newProjectName	� 	�	�	� l !>	�	�	�	� r  !>
 

  l !:
�e�d
 I !:�c�b
�c 0 searchreplace searchReplace�b  
 �a


�a 
into
 o  %(�`�`  0 newprojectname newProjectName
 �_


�_ 
at  
 m  +.

 �
	
	   
 �^

�]�^ 0 replacestring replaceString

 m  14

 �

  �]  �e  �d  
 o      �\�\  0 newprojectname newProjectName	�   remove all spaces   	� �

 $   r e m o v e   a l l   s p a c e s	� 


 l ??�[�Z�Y�[  �Z  �Y  
 


 l ??�X�W�V�X  �W  �V  
 


 l ??�U

�U  
 ? 9 User provides the current prefix of the original project   
 �

 r   U s e r   p r o v i d e s   t h e   c u r r e n t   p r e f i x   o f   t h e   o r i g i n a l   p r o j e c t
 


 I ?d�T


�T .sysodlogaskr        TEXT
 l ?L
�S�R
 b  ?L


 b  ?H


 m  ?B
 
  �
!
! > W h a t   i s   t h e   c u r r e n t   p r e f i x   f o r  
 o  BG�Q�Q  0 oldprojectname oldProjectName
 m  HK
"
" �
#
#    ?�S  �R  
 �P
$
%
�P 
dtxt
$ m  OR
&
& �
'
'  F T
% �O
(
)
�O 
btns
( J  UZ
*
* 
+�N
+ m  UX
,
, �
-
-  O K�N  
) �M
.�L
�M 
dflt
. m  ]^�K�K �L  
 
/
0
/ s  e�
1
2
1 c  el
3
4
3 l eh
5�J�I
5 1  eh�H
�H 
rslt�J  �I  
4 m  hk�G
�G 
list
2 J      
6
6 
7
8
7 o      �F�F 0 button_pressed  
8 
9�E
9 o      �D�D 0 text_returned  �E  
0 
:
;
: r  ��
<
=
< c  ��
>
?
> o  ���C�C 0 text_returned  
? m  ���B
�B 
TEXT
= o      �A�A 0 
old_prefix  
; 
@
A
@ l ��
B
C
D
B r  ��
E
F
E l ��
G�@�?
G I ���>�=
H�> 0 searchreplace searchReplace�=  
H �<
I
J
�< 
into
I o  ���;�; 0 
old_prefix  
J �:
K
L
�: 
at  
K m  ��
M
M �
N
N   
L �9
O�8�9 0 replacestring replaceString
O m  ��
P
P �
Q
Q  �8  �@  �?  
F o      �7�7 0 
old_prefix  
C   remove all spaces   
D �
R
R $   r e m o v e   a l l   s p a c e s
A 
S
T
S r  ��
U
V
U I  ���6
W�5�6 0 upcase upCase
W 
X�4
X o  ���3�3 0 
old_prefix  �4  �5  
V o      �2�2 0 
old_prefix  
T 
Y
Z
Y r  ��
[
\
[ [  ��
]
^
] l ��
_�1�0
_ I ���/
`�.
�/ .corecnte****       ****
` o  ���-�- 0 
old_prefix  �.  �1  �0  
^ m  ���,�, 
\ o      �+�+ 0 kernel_beginning  
Z 
a
b
a Z  ��
c
d�*�)
c E  ��
e
f
e o  ���(�(  0 myreservedlist myReservedList
f o  ���'�' 0 
old_prefix  
d k  ��
g
g 
h
i
h I ���&�%�$
�& .sysobeepnull��� ��� long�%  �$  
i 
j
k
j I ���#
l
m
�# .sysodlogaskr        TEXT
l m  ��
n
n �
o
o W A R N I N G   - -   Y o u r   o r i g i n a l   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   T h e   p r o j e c t   i s   n o t   c l o n a b l e .   E x i t   n o w .
m �"
p�!
�" 
disp
p m  ��� 
�  stic    �!  
k 
q�
q l ��
r
s
t
r L  ����  
s   abort program   
t �
u
u    a b o r t   p r o g r a m�  �*  �)  
b 
v
w
v l ������  �  �  
w 
x
y
x l ���
z
{�  
z 4 . User chooses new prefix to replace old prefix   
{ �
|
| \   U s e r   c h o o s e s   n e w   p r e f i x   t o   r e p l a c e   o l d   p r e f i x
y 
}
~
} T  ��

 k  ��
�
� 
�
�
� I ��
�
�
� .sysodlogaskr        TEXT
� l � 
���
� b  � 
�
�
� b  ��
�
�
� m  ��
�
� �
�
� 6 W h a t   i s   t h e   n e w   p r e f i x   f o r  
� o  ����  0 newprojectname newProjectName
� m  ��
�
� �
�
�    ?  �  �  
� �
�
�
� 
dtxt
� m  
�
� �
�
�  
� �
�
�
� 
btns
� J  	
�
� 
��
� m  	
�
� �
�
�  O K�  
� �
��
� 
dflt
� m  �� �  
� 
�
�
� s  9
�
�
� c   
�
�
� l 
���
� 1  �
� 
rslt�  �  
� m  �
� 
list
� J      
�
� 
�
�
� o      �� 0 button_pressed  
� 
��

� o      �	�	 0 text_returned  �
  
� 
�
�
� r  :E
�
�
� c  :A
�
�
� o  :=�� 0 text_returned  
� m  =@�
� 
TEXT
� o      �� 0 
new_prefix  
� 
��
� Q  F�
�
�
�
� k  I�
�
� 
�
�
� l IP
�
�
�
� r  IP
�
�
� m  IL�� 0
� o      �� 0 n  
�   zero   
� �
�
� 
   z e r o
� 
�
�
� U  Q�
�
�
� k  Z�
�
� 
�
�
� Z  Z�
�
���
� ?  Zs
�
�
� l Zq
�� ��
� I Zq����
�
�� .sysooffslong    ��� null��  
� ��
�
�
�� 
psof
� l ^e
�����
� I ^e��
���
�� .sysontocTEXT       shor
� o  ^a���� 0 n  ��  ��  ��  
� ��
���
�� 
psin
� o  hk���� 0 
new_prefix  ��  �   ��  
� m  qr����  
� R  v|��
���
�� .ascrerr ****      � ****
� m  x{
�
� �
�
� L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x��  �  �  
� 
���
� r  ��
�
�
� [  ��
�
�
� o  ������ 0 n  
� m  ������ 
� o      ���� 0 n  ��  
� m  TW���� 

� 
�
�
� l ��
�
�
�
� r  ��
�
�
� l ��
�����
� I ������
��� 0 searchreplace searchReplace��  
� ��
�
�
�� 
into
� o  ������ 0 
new_prefix  
� ��
�
�
�� 
at  
� m  ��
�
� �
�
�   
� ��
����� 0 replacestring replaceString
� m  ��
�
� �
�
�  ��  ��  ��  
� o      ���� 0 
new_prefix  
�   remove all spaces   
� �
�
� $   r e m o v e   a l l   s p a c e s
� 
�
�
� r  ��
�
�
� I  ����
����� 0 upcase upCase
� 
���
� o  ������ 0 
new_prefix  ��  ��  
� o      ���� 0 
new_prefix  
� 
���
� Z  ��
�
���
�
� E  ��
�
�
� o  ������  0 myreservedlist myReservedList
� o  ������ 0 
new_prefix  
� k  ��
�
� 
�
�
� I ��������
�� .sysobeepnull��� ��� long��  ��  
� 
���
� I ����
�
�
�� .sysodlogaskr        TEXT
� m  ��
�
� �
�
�  W A R N I N G !   - -   Y o u r   n e w   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   A d d i n g   X ,   Y   o r   Z   t o   t h e   b e g i n n i n g   w o u l d   b e   a c c e p t a b l e .
� ��
���
�� 
disp
� m  ����
�� stic    ��  ��  ��  
�  S  ����  
� R      ������
�� .ascrerr ****      � ****��  ��  
� I ����
�
�
�� .sysodlogaskr        TEXT
� m  ��
�
� �
�
� L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x
� ��
���
�� 
disp
� m  ����
�� stic    ��  �  
~ 
�
�
� l ����������  ��  ��  
�    l ����������  ��  ��    l ������   / ) end of setup  //////////////////////////    � R   e n d   o f   s e t u p     / / / / / / / / / / / / / / / / / / / / / / / / / /  l ����������  ��  ��   	
	 I �6��
�� .sysodlogaskr        TEXT l ����� b  � b  � b  � b  � b  � b  � b  �  m  �� � ^ T h i s   i s   w h a t   w i l l   b e   u s e d : 
 o r i g i n a l   p r o j e c t : 	 	   o  ������  0 oldprojectname oldProjectName m    �   
 n e w   p r o j e c t : 	 	   o  ����  0 newprojectname newProjectName m     �!! & 
 o r i g i n a l   p r e f i x : 	 	 o  ���� 0 
old_prefix   m  "" �##  
 n e w   p r e f i x : 	 	 o  ���� 0 
new_prefix  ��  ��   ��$%
�� 
btns$ J  &&& '(' m  )) �**  O K( +,+ m  !-- �..  R E S U B M I T, /��/ m  !$00 �11  E X I T��  % ��23
�� 
dflt2 m  )*���� 3 ��4��
�� 
disp4 m  -0��
�� stic   ��  
 565 s  7K787 c  7>9:9 l 7:;����; 1  7:��
�� 
rslt��  ��  : m  :=��
�� 
list8 J      << =��= o      ���� 0 buttonpressed buttonPressed��  6 >?> l LL��������  ��  ��  ? @A@ Z  L�BC����B > LSDED o  LO���� 0 buttonpressed buttonPressedE m  ORFF �GG  E X I TC l V�HIJH Z  V�KLM��K = V]NON o  VY����  0 newprojectname newProjectNameO m  Y\PP �QQ  L k  `uRR STS r  `gUVU m  `cWW �XX  R E S U B M I TV o      ���� 0 buttonpressed buttonPressedT Y��Y I hu��Z[
�� .sysodlogaskr        TEXTZ m  hk\\ �]] � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .[ ��^��
�� 
disp^ m  nq��
�� stic    ��  ��  M _`_ = xaba o  x{���� 0 
old_prefix  b m  {~cc �dd  ` efe k  ��gg hih r  ��jkj m  ��ll �mm  R E S U B M I Tk o      ���� 0 buttonpressed buttonPressedi n��n I ����op
�� .sysodlogaskr        TEXTo m  ��qq �rr � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .p ��s��
�� 
disps m  ����
�� stic    ��  ��  f tut = ��vwv o  ������ 0 
new_prefix  w m  ��xx �yy  u z��z k  ��{{ |}| r  ��~~ m  ���� ���  R E S U B M I T o      ���� 0 buttonpressed buttonPressed} ���� I ������
�� .sysodlogaskr        TEXT� m  ���� ��� � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .� �����
�� 
disp� m  ����
�� stic    ��  ��  ��  ��  I ; 5 this checks to see if any answers were a null string   J ��� j   t h i s   c h e c k s   t o   s e e   i f   a n y   a n s w e r s   w e r e   a   n u l l   s t r i n g��  ��  A ���� l ����������  ��  ��  ��  	c =  ( /��� o   ( +���� 0 buttonpressed buttonPressed� m   + .�� ���  R E S U B M I T��  ��  	` ��� l     ��������  ��  ��  � ��� l �������� Z  ��������� = ����� o  ������ 0 buttonpressed buttonPressed� m  ���� ���  E X I T� l ������ L  ������  � $  abort program by user request   � ��� <   a b o r t   p r o g r a m   b y   u s e r   r e q u e s t��  ��  ��  ��  � ��� l     ����~��  �  �~  � ��� l     �}���}  �  ////// end of User Input   � ��� 0 / / / / / /   e n d   o f   U s e r   I n p u t� ��� l     �|�{�z�|  �{  �z  � ��� l     �y�x�w�y  �x  �w  � ��� l     �v���v  � / ) Duplicate original Xcode project folder    � ��� R   D u p l i c a t e   o r i g i n a l   X c o d e   p r o j e c t   f o l d e r  � ��� l ����u�t� O  ����� r  ����� I ���s��r
�s .coreclon****      � ****� o  ���q�q 0 	thefolder 	theFolder�r  � o      �p�p 0 	newfolder 	newFolder� m  �����                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �u  �t  � ��� l     �o�n�m�o  �n  �m  � ��� l     �l���l  � = 7 set POSIX path for duplicated Folder for shell scripts   � ��� n   s e t   P O S I X   p a t h   f o r   d u p l i c a t e d   F o l d e r   f o r   s h e l l   s c r i p t s� ��� l ���k�j� r  ���� c  ����� b  ����� b  ����� o  ���i�i 0 myhome myHome� o  ���h�h  0 oldprojectname oldProjectName� m  ���� ���    c o p y /� m  ���g
�g 
TEXT� o      �f�f 0 mypath myPath�k  �j  � ��� l     �e�d�c�e  �d  �c  � ��� l     �b���b  �   create new project   � ��� &   c r e a t e   n e w   p r o j e c t� ��� l     �a���a  � ) # Launch ProgBar for the first time.   � ��� F   L a u n c h   P r o g B a r   f o r   t h e   f i r s t   t i m e .� ��� l 
��`�_� n  
��� I  
�^�]�\�^ 0 startprogbar startProgBar�]  �\  �  f  �`  �_  � ��� l     �[�Z�Y�[  �Z  �Y  � ��� l Z��X�W� O  Z��� k  Y�� ��� l �V�U�T�V  �U  �T  � ��� l �S���S  � U O clean out duplicated project build folder before making list of project items    � ��� �   c l e a n   o u t   d u p l i c a t e d   p r o j e c t   b u i l d   f o l d e r   b e f o r e   m a k i n g   l i s t   o f   p r o j e c t   i t e m s  � ��� r  ��� c  ��� o  �R�R 0 	newfolder 	newFolder� m  �Q
�Q 
ctxt� o      �P�P 0 mybuildpath myBuildPath� ��O� Q  Y���N� k   P�� ��� r   /��� c   +��� b   '��� o   #�M�M 0 mybuildpath myBuildPath� m  #&�� ��� 
 b u i l d� m  '*�L
�L 
alis� o      �K�K 0 mybuildpath myBuildPath� ��J� Z  0P� �I�H� > 0> l 0;�G�F I 0;�E
�E .earslfdrutxt  @    file o  03�D�D 0 mybuildpath myBuildPath �C�B
�C 
lfiv m  67�A
�A boovfals�B  �G  �F   J  ;=�@�@    I AL�?�>
�? .coredelonull���     obj  n  AH	 2 DH�=
�= 
cobj	 o  AD�<�< 0 mybuildpath myBuildPath�>  �I  �H  �J  � R      �;�:�9
�; .ascrerr ****      � ****�:  �9  �N  �O  � m  

�                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �X  �W  �  l [v I  [v�8�7�8 0 doonefolder doOneFolder  o  \_�6�6 0 	newfolder 	newFolder  o  _b�5�5 0 mybuildpath myBuildPath  o  be�4�4 0 
old_prefix    o  eh�3�3 0 
new_prefix    o  hm�2�2  0 oldprojectname oldProjectName �1 o  mp�0�0  0 newprojectname newProjectName�1  �7   &   process all folders recursively    � @   p r o c e s s   a l l   f o l d e r s   r e c u r s i v e l y  l w� ! O  w�"#" k  }�$$ %&% l }�'()' r  }�*+* o  }��/�/  0 newprojectname newProjectName+ n      ,-, 1  ���.
�. 
pnam- o  ���-�- 0 	newfolder 	newFolder( : 4 finally rename duplicate folder to new project name   ) �.. h   f i n a l l y   r e n a m e   d u p l i c a t e   f o l d e r   t o   n e w   p r o j e c t   n a m e& /�,/ l ��0120 n  ��343 I  ���+�*�)�+ 0 stopprogbar stopProgBar�*  �)  4  f  ��1 I C Conclude the progress bar. This 'resets' the progress bar's state.   2 �55 �   C o n c l u d e   t h e   p r o g r e s s   b a r .   T h i s   ' r e s e t s '   t h e   p r o g r e s s   b a r ' s   s t a t e .�,  # m  wz66�                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��    0 * end finder script for renaming everything   ! �77 T   e n d   f i n d e r   s c r i p t   f o r   r e n a m i n g   e v e r y t h i n g 898 l     �(�'�&�(  �'  �&  9 :;: l     �%<=�%  < � z Go into Project .xcodeproj package and replace all prefixes and names to fix broken links within xcode paths and targets    = �>> �   G o   i n t o   P r o j e c t   . x c o d e p r o j   p a c k a g e   a n d   r e p l a c e   a l l   p r e f i x e s   a n d   n a m e s   t o   f i x   b r o k e n   l i n k s   w i t h i n   x c o d e   p a t h s   a n d   t a r g e t s  ; ?@? l ��A�$�#A r  ��BCB c  ��DED b  ��FGF b  ��HIH b  ��JKJ b  ��LML o  ���"�" 0 myhome myHomeM o  ���!�!  0 newprojectname newProjectNameK m  ��NN �OO  /I o  ��� �   0 newprojectname newProjectNameG m  ��PP �QQ  . x c o d e p r o jE m  ���
� 
TEXTC o      �� 0 mypath myPath�$  �#  @ RSR l ��TUVT r  ��WXW m  ��YY �ZZ  . p b x p r o jX o      �� 0 
filesuffix 
fileSuffixU   set global variable   V �[[ (   s e t   g l o b a l   v a r i a b l eS \]\ l     ����  �  �  ] ^_^ l ��`��` I  ���a�� &0 simplereplacetext simpleReplaceTexta bcb m  ��dd �ee  p r o j e c t . p b x p r o jc fgf o  ����  0 oldprojectname oldProjectNameg h�h o  ����  0 newprojectname newProjectName�  �  �  �  _ iji l     ����  �  �  j klk l     �mn�  m _ Y --------more detailed search of project file structure to prevent incorrect replacements   n �oo �   - - - - - - - - m o r e   d e t a i l e d   s e a r c h   o f   p r o j e c t   f i l e   s t r u c t u r e   t o   p r e v e n t   i n c o r r e c t   r e p l a c e m e n t sl pqp l ��r��r r  ��sts c  ��uvu b  ��wxw m  ��yy �zz  p a t h   =  x o  ���� 0 
old_prefix  v m  ���
� 
TEXTt o      �
�
 0 pathoprefix  �  �  q {|{ l ��}�	�} r  ��~~ c  ����� b  ����� m  ���� ���  p a t h   =  � o  ���� 0 
new_prefix  � m  ���
� 
TEXT o      �� 0 pathnprefix  �	  �  | ��� l ������ I  ������ &0 simplereplacetext simpleReplaceText� ��� m  ���� ���  p r o j e c t . p b x p r o j� ��� o  ��� �  0 pathoprefix  � ���� o  ������ 0 pathnprefix  ��  �  �  �  � ��� l     ��������  ��  ��  � ��� l ������� r  ���� c  ���� b  ����� m  ���� ���  n a m e   =  � o  ������ 0 
old_prefix  � m  ���
�� 
TEXT� o      ���� 0 nameoprefix  ��  ��  � ��� l ������ r  ��� c  ��� b  ��� m  �� ���  n a m e   =  � o  ���� 0 
new_prefix  � m  ��
�� 
TEXT� o      ���� 0 namenprefix  ��  ��  � ��� l &������ I  &������� &0 simplereplacetext simpleReplaceText� ��� m  �� ���  p r o j e c t . p b x p r o j� ��� o  ���� 0 nameoprefix  � ���� o  "���� 0 namenprefix  ��  ��  ��  ��  � ��� l     ��������  ��  ��  � ��� l '6������ r  '6��� c  '2��� b  '.��� m  '*�� ���  H E A D E R   =  � o  *-���� 0 
old_prefix  � m  .1��
�� 
TEXT� o      ���� 0 nameoprefix  ��  ��  � ��� l 7F������ r  7F��� c  7B��� b  7>��� m  7:�� ���  H E A D E R   =  � o  :=���� 0 
new_prefix  � m  >A��
�� 
TEXT� o      ���� 0 namenprefix  ��  ��  � ��� l GU������ I  GU������� &0 simplereplacetext simpleReplaceText� ��� m  HK�� ���  p r o j e c t . p b x p r o j� ��� o  KN���� 0 nameoprefix  � ���� o  NQ���� 0 namenprefix  ��  ��  ��  ��  � ��� l     ��������  ��  ��  � ��� l Vo������ r  Vo��� c  Vk��� b  Vg��� b  Vc��� b  V_��� m  VY�� ���  p a t h   =  � o  Y^���� 0 	nibfolder 	nibFolder� m  _b�� ���  \ /� o  cf���� 0 
old_prefix  � m  gj��
�� 
TEXT� o      ���� 0 nibpathoprefix  ��  ��  � ��� l p������� r  p���� c  p���� b  p���� b  p}��� b  py��� m  ps�� ���  p a t h   =  � o  sx���� 0 	nibfolder 	nibFolder� m  y|�� ���  \ /� o  }����� 0 
new_prefix  � m  ����
�� 
TEXT� o      ���� 0 nibpathnprefix  ��  ��  � ��� l �������� I  ��������� &0 simplereplacetext simpleReplaceText� � � m  �� �  p r o j e c t . p b x p r o j   o  ������ 0 nibpathoprefix   �� o  ������ 0 nibpathnprefix  ��  ��  ��  ��  �  l     ��������  ��  ��   	 l ��
����
 r  �� c  �� b  �� b  �� b  �� m  �� �  n a m e   =   o  ������ 0 	nibfolder 	nibFolder m  �� �  \ / o  ������ 0 
old_prefix   m  ����
�� 
TEXT o      ���� 0 nibpathoprefix  ��  ��  	  l ������ r  �� c  �� b  �� !  b  ��"#" b  ��$%$ m  ��&& �''  n a m e   =  % o  ������ 0 	nibfolder 	nibFolder# m  ��(( �))  \ /! o  ������ 0 
new_prefix   m  ����
�� 
TEXT o      ���� 0 nibpathnprefix  ��  ��   *+* l ��,����, I  ����-���� &0 simplereplacetext simpleReplaceText- ./. m  ��00 �11  p r o j e c t . p b x p r o j/ 232 o  ������ 0 nibpathoprefix  3 4��4 o  ������ 0 nibpathnprefix  ��  ��  ��  ��  + 565 l     ��������  ��  ��  6 787 l ��9����9 r  ��:;: c  ��<=< b  ��>?> b  ��@A@ b  ��BCB m  ��DD �EE  p a t h   =  C o  ������ 0 	xibfolder 	xibFolderA m  ��FF �GG  \ /? o  ������ 0 
old_prefix  = m  ����
�� 
TEXT; o      ���� 0 xibpathoprefix  ��  ��  8 HIH l �J����J r  �KLK c  �MNM b  �OPO b  �QRQ b  ��STS m  ��UU �VV  p a t h   =  T o  ������ 0 	xibfolder 	xibFolderR m  �WW �XX  \ /P o  ���� 0 
new_prefix  N m  
��
�� 
TEXTL o      ���� 0 xibpathnprefix  ��  ��  I YZY l [����[ I  ��\���� &0 simplereplacetext simpleReplaceText\ ]^] m  __ �``  p r o j e c t . p b x p r o j^ aba o  ���� 0 xibpathoprefix  b c��c o  ���� 0 xibpathnprefix  ��  ��  ��  ��  Z ded l     ��������  ��  ��  e fgf l 8h����h r  8iji c  4klk b  0mnm b  ,opo b  (qrq m  "ss �tt  n a m e   =  r o  "'���� 0 matlabfolder matlabFolderp m  (+uu �vv  \ /n o  ,/���� 0 
old_prefix  l m  03��
�� 
TEXTj o      ���� &0 matlabpathoprefix matlabPathoprefix��  ��  g wxw l 9Ry����y r  9Rz{z c  9N|}| b  9J~~ b  9F��� b  9B��� m  9<�� ���  n a m e   =  � o  <A���� 0 matlabfolder matlabFolder� m  BE�� ���  \ / o  FI���� 0 
new_prefix  } m  JM��
�� 
TEXT{ o      ���� &0 matlabpathnprefix matlabPathnprefix��  ��  x ��� l Sa������ I  Sa������� &0 simplereplacetext simpleReplaceText� ��� m  TW�� ���  p r o j e c t . p b x p r o j� ��� o  WZ���� &0 matlabpathoprefix matlabPathoprefix� ��� o  Z]�~�~ &0 matlabpathnprefix matlabPathnprefix�  ��  ��  ��  � ��� l     �}�|�{�}  �|  �{  � ��� l     �z���z  �   clean new project   � ��� $   c l e a n   n e w   p r o j e c t� ��� l bw��y�x� r  bw��� c  bq��� b  bm��� b  bi��� o  be�w�w 0 myhome myHome� o  eh�v�v  0 newprojectname newProjectName� m  il�� ���  /� m  mp�u
�u 
TEXT� o      �t�t 0 mypath myPath�y  �x  � ��� l x����� r  x���� l x���s�r� I x��q�p��q 0 searchreplace searchReplace�p  � �o��
�o 
into� o  |��n�n 0 mypath myPath� �m��
�m 
at  � l ����l�k� m  ���� ���   �l  �k  � �j��i�j 0 replacestring replaceString� m  ���� ���  \ %�i  �s  �r  � o      �h�h 0 	shellpath 	ShellPath� H B uses global variable to overcome POSIX issue with spaces in names   � ��� �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s� ��� l ����g�f� r  ����� l ����e�d� I ���c�b��c 0 searchreplace searchReplace�b  � �a��
�a 
into� o  ���`�` 0 	shellpath 	ShellPath� �_��
�_ 
at  � m  ���� ���  %� �^��]�^ 0 replacestring replaceString� m  ���� ���   �]  �e  �d  � o      �\�\ 0 	shellpath 	ShellPath�g  �f  � ��� l     �[���[  � h bset cmd to "rm " & ShellPath & replaceScriptName -- remove sed script file from new project folder   � ��� � s e t   c m d   t o   " r m   "   &   S h e l l P a t h   &   r e p l a c e S c r i p t N a m e   - -   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e r� ��� l     �Z���Z  �  do shell script cmd   � ��� & d o   s h e l l   s c r i p t   c m d� ��� l ����Y�X� r  ����� b  ����� b  ����� m  ���� ���  c d  � o  ���W�W 0 	shellpath 	ShellPath� m  ���� ��� < ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a n� o      �V�V 0 cmd  �Y  �X  � ��� l ����U�T� I ���S��R
�S .sysoexecTEXT���     TEXT� o  ���Q�Q 0 cmd  �R  �U  �T  � ��� l     �P�O�N�P  �O  �N  � ��� l     �M���M  �   end of copyXproject   � ��� (   e n d   o f   c o p y X p r o j e c t� ��� l ����L�K� I ���J�I�H
�J .miscactvnull��� ��� null�I  �H  �L  �K  � ��� l ����G�F� I ���E��
�E .sysodlogaskr        TEXT� b  ����� o  ���D�D  0 newprojectname newProjectName� m  ���� ��� $   h a s   b e e n   c r e a t e d !� �C��B
�C 
disp� m  ���A
�A stic   �B  �G  �F  � ��� l     �@�?�>�@  �?  �>  � ��=� l     �<�;�:�<  �;  �:  �=       �9� > G P Y b k t�� 	
�9  � �8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�8 0 	nibfolder 	nibFolder�7 0 	xibfolder 	xibFolder�6 0 matlabfolder matlabFolder�5 &0 replacescriptname replaceScriptName�4  0 oldprojectname oldProjectName�3 0 mypath myPath�2 0 
filesuffix 
fileSuffix�1 0 doonefolder doOneFolder�0 &0 replacetextinfile replaceTextInFile�/ &0 simplereplacetext simpleReplaceText�. 0 searchreplace searchReplace�- 0 upcase upCase�,  0 prepareprogbar prepareProgBar�+ $0 incrementprogbar incrementProgBar�* 0 fadeinprogbar fadeinProgBar�)  0 fadeoutprogbar fadeoutProgBar�( 0 showprogbar showProgBar�' 0 hideprogbar hideProgBar�& 0 
barberpole 
barberPole�%  0 killbarberpole killBarberPole�$ 0 startprogbar startProgBar�# 0 stopprogbar stopProgBar
�" .aevtoappnull  �   � ****� �! �� ���! 0 doonefolder doOneFolder�  ��   ������� 0 	thefolder 	theFolder� 0 	buildpath 	buildPath� 0 
old_prefix  � 0 
new_prefix  �  0 oldprojectname oldProjectName�  0 newprojectname newProjectName�   �������������
�	�� 0 	thefolder 	theFolder� 0 	buildpath 	buildPath� 0 
old_prefix  � 0 
new_prefix  �  0 oldprojectname oldProjectName�  0 newprojectname newProjectName� 0 
folderlist 
folderList� 0 f  � 0 numfiles numFiles� 0 n  � 0 currentfile currentFile� &0 pathtocurrentfile pathToCurrentFile�
 0 filename_kernel  �	 0 testchar testChar� 
0 locase   E�������� ���������������������#.:\bn��������	��������C����������������������
",:BOkv~�
� 
cfol
� 
pnam
� 
leng
� 
ctxt
� 
cobj
� 
alis� �  0 doonefolder doOneFolder
�� 
file�� 0 filelist fileList
�� 
rslt
�� .corecnte****       ****��  0 prepareprogbar prepareProgBar�� 0 fadeinprogbar fadeinProgBar�� $0 incrementprogbar incrementProgBar�� 0 kernel_beginning  �� &0 replacetextinfile replaceTextInFile
�� 
docf
�� .sysoctonshor       TEXT�� A�� Z
�� 
bool��  
�� .sysontocTEXT       shor�� &0 simplereplacetext simpleReplaceText
�� 
into
�� 
at  �� 0 replacestring replaceString�� 0 searchreplace searchReplace�� 
��-�,EE�UO 'k��,Ekh *��&��/%�&������+ OP[OY��O�ՠ�-�,EE�O�j O�E�O)�kl+ O)kk+ O�k�kh 	)��km+ O��/EE�O��&��/%E�O��몤 Ca E�O _ �j kh 	���/%E�[OY��O)��&������+ O��%�a �/�,FY��a  �a %�a �/�,FY��a  �a %�a �/�,FYl�a  /)��&������+ O��a %  �a %�a �/�,FY hY7�a  J)��&������+ O��a %  �a %�a �/�,FY ��a %  �a %�a �/�,FY hY 窤a  %  �a !%��b   /a �/�,FY Ū�a "%  !)��&������+ O�a #%�a �/�,FY ��a $ �a %Ec  O)��&������+ O��k/j &E�O�a '	 �a (a )& 4a *E�O l�j kh 	���/%E�[OY��O�a +j ,�%E�Y hO)���m+ -O)a .�a /�a 0�� 1�a �/�,FY hOPY��a 2 �a 3%�a �/�,FY~�a 4 �a 5%�a �/�,FYe�a 6 /)��&������+ O��a 7%  �a 8%�a �/�,FY hY0�a 9 J)��&������+ O��a :%  �a ;%�a �/�,FY ��a <%  �a =%�a �/�,FY hY તa >%  �a ?%�a �/�,FY Ū�a @%  !)��&������+ O�a A%�a �/�,FY ��a B �a CEc  O)��&������+ O��k/j &E�O�a '	 �a (a )& 4a DE�O l�j kh 	���/%E�[OY��O�a +j ,�%E�Y hO)���m+ -O)a .�a /�a 0�� 1�a �/�,FY h[OY�ZOPU� ����������� &0 replacetextinfile replaceTextInFile�� ����   �������������� 0 	thefolder 	theFolder�� 0 thefile theFile�� 0 oldtext1  �� 0 newtext1  �� 0 oldtext2  �� 0 newtext2  ��   �������������������������� 0 	thefolder 	theFolder�� 0 thefile theFile�� 0 oldtext1  �� 0 newtext1  �� 0 oldtext2  �� 0 newtext2  �� 0 tempfile tempFile�� 0 myfolderpath myFolderPath�� 0 filename fileName�� 0 fileid fileID�� 0 	shellpath 	ShellPath�� 0 cmd   4����������MOQ����UW[]_c���������������������������������"$&(*,.024I
�� 
psxp
�� 
TEXT
�� 
psxf
�� 
perm
�� .rdwropenshor       file�� 

�� .sysontocTEXT       shor
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****
�� 
into
�� 
at  �� 0 replacestring replaceString�� �� 0 searchreplace searchReplace
�� .sysoexecTEXT���     TEXT��Q�E�O��,�&E�O�b  %E�O*�/�el E�O�%�%�%�%�j 
%�%�%�%�j 
%�%�%�%�%�%�j 
%a %a �l O�j O��,�&E�O*a �a a a a a  E�O*a �a a a a a  E�Oa �%�%a %�%�%a %a  %�%�%a !%a "%�%a #%�%a $%�%�%a %%�%�%a &%a '%�%�%E�O�j (Oa )�%�%a *%�%�%a +%a ,%�%�%a -%a .%�%b  %a /%�%�%a 0%�%�%a 1%a 2%�%�%E�O�j (Oa 3�%b  %E�O�j (  ��X�������� &0 simplereplacetext simpleReplaceText�� ����   �������� 0 thefile theFile�� 0 oldtext  �� 0 newtext newText��   �������������� 0 thefile theFile�� 0 oldtext  �� 0 newtext newText�� 0 tempfile tempFile�� 0 	shellpath 	ShellPath�� 0 cmd   k������|�������������������
�� 
TEXT
�� 
into
�� 
at  �� 0 replacestring replaceString�� �� 0 searchreplace searchReplace
�� .sysoexecTEXT���     TEXT�� `�b  %�&E�O*�b  ����� E�O*������ E�O�%�%�%�%�%�%�%�%�%a %�%a %�%a %�%a %�%E�O�j  ����������� 0 searchreplace searchReplace��  �� ����
�� 
into�� 0 
mainstring 
mainString ����
�� 
at  �� 0 searchstring searchString �������� 0 replacestring replaceString�� 0 replacestring replaceString��   �������������� 0 
mainstring 
mainString�� 0 searchstring searchString�� 0 replacestring replaceString�� 0 foundoffset foundOffset�� 0 stringstart stringStart�� 0 	stringend 	stringEnd ������������
�� 
psof
�� 
psin�� 
�� .sysooffslong    ��� null
�� 
ctxt
�� .corecnte****       ****�� T Oh��*��� E�O�k  �E�Y �[�\[Zk\Z�k2E�O�[�\[Z��j \Zi2E�O��%�%E�[OY��O� ��?�������� 0 upcase upCase�� ����   ���� 0 astring aString��   ���������� 0 astring aString�� 
0 buffer  �� 0 i  �� 0 testchar testChar 	G����������������
�� .corecnte****       ****
�� 
cobj
�� .sysoctonshor       TEXT�� a�� z
�� 
bool��  
�� .sysontocTEXT       shor�� Q�E�O Hk�j kh ��/j E�O��	 ���& ���j %E�OPY ��j %E�OPOP[OY��O� �����������  0 prepareprogbar prepareProgBar�� �� ��    ����� 0 somemaxcount someMaxCount� 0 
windowname 
windowName��   �~�}�~ 0 somemaxcount someMaxCount�} 0 
windowname 
windowName �|�{�z�y�x�w�v�u�t�s�r�q��p�o�n�m�l�|   ��
�{ 
cwin
�z 
bacC
�y 
hasS�x �w �v �u e�t��s 
�r 
cobj
�q 
levV
�p 
titl
�o 
proI
�n 
conT
�m 
minW
�l 
maxV�� b� ^���mv*�/�,FOe*�/�,FOjm������v��/*�/�,FO�*�/�,FOj*�/�k/a ,FOj*�/�k/a ,FO�*�/�k/a ,FU �k�j�i!"�h�k $0 incrementprogbar incrementProgBar�j �g#�g #  �f�e�d�f 0 
itemnumber 
itemNumber�e 0 somemaxcount someMaxCount�d 0 
windowname 
windowName�i  ! �c�b�a�c 0 
itemnumber 
itemNumber�b 0 somemaxcount someMaxCount�a 0 
windowname 
windowName" 
@*,.�`�_�^�]�\�[�` 0 filelist fileList
�_ 
cobj
�^ 
cwin
�] 
titl
�\ 
proI
�[ 
conT�h '� #�%�%�%�%��/%*�/�,FO�*�/�k/�,FU �ZK�Y�X$%�W�Z 0 fadeinprogbar fadeinProgBar�Y �V&�V &  �U�U 0 
windowname 
windowName�X  $ �T�S�R�T 0 
windowname 
windowName�S 0 	fadevalue 	fadeValue�R 0 i  % 
��Q�P�O�Ng�M�L�K�J
�Q 
cwin
�P .appScentnull���    obj 
�O 
alpV
�N 
pvis�M 	
�L 
proI
�K 
usTA
�J .coVSstaAnull���    obj �W P� L*�/j Oj*�/�,FOe*�/�,FO�E�O j�kh �*�/�,FO��E�[OY��O*�/�k/�el 	U �I��H�G'(�F�I  0 fadeoutprogbar fadeoutProgBar�H �E)�E )  �D�D 0 
windowname 
windowName�G  ' �C�B�A�C 0 
windowname 
windowName�B 0 	fadevalue 	fadeValue�A 0 i  ( 
��@�?�>�=��<�;��:
�@ 
cwin
�? 
proI
�> 
usTA
�= .coVSstoTnull���    obj �< 	
�; 
alpV
�: 
pvis�F >� :*�/�k/�el O�E�O k�kh �*�/�,FO��E�[OY��Of*�/�,FU �9��8�7*+�6�9 0 showprogbar showProgBar�8 �5,�5 ,  �4�4 0 
windowname 
windowName�7  * �3�3 0 
windowname 
windowName+ ��2�1�0�/�.�-
�2 
cwin
�1 .appScentnull���    obj 
�0 
pvis
�/ 
proI
�. 
usTA
�- .coVSstaAnull���    obj �6 %� !*�/j Oe*�/�,FO*�/�k/�el U �,��+�*-.�)�, 0 hideprogbar hideProgBar�+ �(/�( /  �'�' 0 
windowname 
windowName�*  - �&�& 0 
windowname 
windowName. ��%�$�#�"�!
�% 
cwin
�$ 
proI
�# 
usTA
�" .coVSstoTnull���    obj 
�! 
pvis�) � *�/�k/�el Of*�/�,FU	 � 	
��01��  0 
barberpole 
barberPole� �2� 2  �� 0 
windowname 
windowName�  0 �� 0 
windowname 
windowName1 	���
� 
cwin
� 
proI
� 
indR� � e*�/�k/�,FU
 �	"��34��  0 killbarberpole killBarberPole� �5� 5  �� 0 
windowname 
windowName�  3 �� 0 
windowname 
windowName4 	/���
� 
cwin
� 
proI
� 
indR� � f*�/�k/�,FU �	:��
67�	� 0 startprogbar startProgBar�  �
  6  7 	=�
� .ascrnoop****      � ****�	 � *j U �	H��89�� 0 stopprogbar stopProgBar�  �  8  9 	K�
� .aevtquitnull��� ��� null� � *j U �:�� ;<��
� .aevtoappnull  �   � ****: k    �==  �>> 	U?? 	_@@ �AA �BB �CC �DD �EE FF GG ?HH RII ^JJ pKK {LL �MM �NN �OO �PP �QQ �RR �SS �TT �UU �VV WW XX *YY 7ZZ H[[ Y\\ f]] w^^ �__ �`` �aa �bb �cc �dd �ee �����  �  �   ;  < � � � � � � � � � � � � � � � � � �����	\�����	s����������������������	���������	�	���	���	���	�����������������������
��
��
 
"
&
,��
M
P������
n����
�
�
�
�������������������
�
�
�
���
� ")-0��FPW\clqx��������������������������NPYd��y������������������������&(0DF��UW��_su������������������������� ��  0 myreservedlist myReservedList�� 0 buttonpressed buttonPressed
�� 
prmp
�� .sysostflalis    ��� null
�� 
alis�� 0 	thefolder 	theFolder
�� .sysonfo4asfe        file
�� 
pnam
�� 
ascr
�� 
txdl�� 0 olddelimiter oldDelimiter
�� 
psxp
�� 
TEXT�� 0 myhome myHome
�� 
citm
�� .corecnte****       ****�� 0 totl  �� 
0 ending  ��  
�� 
dtxt
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT
�� 
rslt
�� 
list
�� 
cobj�� 0 button_pressed  �� 0 text_returned  ��  0 newprojectname newProjectName
�� 
into
�� 
at  �� 0 replacestring replaceString�� 0 searchreplace searchReplace�� 0 
old_prefix  �� 0 upcase upCase�� 0 kernel_beginning  
�� .sysobeepnull��� ��� long
�� 
disp
�� stic    �� 0 
new_prefix  �� 0�� 0 n  �� 

�� 
psof
�� .sysontocTEXT       shor
�� 
psin�� 
�� .sysooffslong    ��� null��  
�� stic   
�� .coreclon****      � ****�� 0 	newfolder 	newFolder�� 0 startprogbar startProgBar
�� 
ctxt�� 0 mybuildpath myBuildPath
�� 
lfiv
�� .earslfdrutxt  @    file
�� .coredelonull���     obj �� 0 doonefolder doOneFolder�� 0 stopprogbar stopProgBar�� &0 simplereplacetext simpleReplaceText�� 0 pathoprefix  �� 0 pathnprefix  �� 0 nameoprefix  �� 0 namenprefix  �� 0 nibpathoprefix  �� 0 nibpathnprefix  �� 0 xibpathoprefix  �� 0 xibpathnprefix  �� &0 matlabpathoprefix matlabPathoprefix�� &0 matlabpathnprefix matlabPathnprefix�� 0 	shellpath 	ShellPath�� 0 cmd  
�� .sysoexecTEXT���     TEXT
�� .miscactvnull��� ��� null�������������������a a vE` Oa E` O�h_ a  *a a l a &E` O_ j a ,Ec  O p_ a ,E` O_ a  ,a !&E` "Oa #_ a ,FO_ "a $-j %E` &O_ &lE` 'O_ "[a $\[Zk\Z_ '2a !&a (%E` "O_ _ a ,FW X ) *_ _ a ,FOa +a ,a -a .a /kva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` 8O*a 9_ 8a :a ;a <a =a 1 >E` 8Oa ?b  %a @%a ,a Aa .a Bkva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` CO*a 9_ Ca :a Da <a Ea 1 >E` CO*_ Ck+ FE` CO_ Cj %kE` GO_ _ C *j HOa Ia Ja Kl 2OhY hOhZa L_ 8%a M%a ,a Na .a Okva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` PO �a QE` RO =a Skh*a T_ Rj Ua V_ Pa W Xj )ja YY hO_ RkE` R[OY��O*a 9_ Pa :a Za <a [a 1 >E` PO*_ Pk+ FE` PO_ _ P *j HOa \a Ja Kl 2Y W X ] *a ^a Ja Kl 2[OY� Oa _b  %a `%_ 8%a a%_ C%a b%_ P%a .a ca da emva 0ka Ja fa 1 2O_ 3a 4&E[a 5k/EQ` ZO_ a g l_ 8a h  a iE` Oa ja Ja Kl 2Y G_ Ca k  a lE` Oa ma Ja Kl 2Y %_ Pa n  a oE` Oa pa Ja Kl 2Y hY hOP[OY�bO_ a q  hY hOa r _ j sE` tUO_ "b  %a u%a !&Ec  O)j+ vOa r J_ ta w&E` xO 5_ xa y%a &E` xO_ xa zfl {jv _ xa 5-j |Y hW X ] *hUO*_ t_ x_ C_ Pb  _ 8a 1+ }Oa r _ 8_ ta ,FO)j+ ~UO_ "_ 8%a %_ 8%a �%a !&Ec  Oa �Ec  O*a �b  _ 8m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b  %a �%_ C%a !&E` �Oa �b  %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b  %a �%_ C%a !&E` �Oa �b  %a �%_ P%a !&E` �O*a �_ �_ �m+ �O_ "_ 8%a �%a !&Ec  O*a 9b  a :a �a <a �a 1 >E` �O*a 9_ �a :a �a <a �a 1 >E` �Oa �_ �%a �%E` �O_ �j �O*j �O_ 8a �%a Ja fl 2ascr  ��ޭ