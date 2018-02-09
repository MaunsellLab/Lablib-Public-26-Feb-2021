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
new_prefix   �  � � � o      ����  0 oldprojectname oldProjectName �  ��� � o      ����  0 newprojectname newProjectName��  ��   � k     � �  � � � l     �� � ���   � - ' Process subfolders first (recursively)    � � � � N   P r o c e s s   s u b f o l d e r s   f i r s t   ( r e c u r s i v e l y ) �  � � � O      � � � l    � � � � r     � � � l   
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
folderList��   HIH l  7 7��JK��  J X R Once the subfolders have been processed, process each of the files in this folder   K �LL �   O n c e   t h e   s u b f o l d e r s   h a v e   b e e n   p r o c e s s e d ,   p r o c e s s   e a c h   o f   t h e   f i l e s   i n   t h i s   f o l d e rI M��M O   7NON k   ;PP QRQ r   ; CSTS e   ; AUU n   ; AVWV 1   > @��
�� 
pnamW n  ; >XYX 2   < >��
�� 
fileY o   ; <���� 0 	thefolder 	theFolderT o      ���� 0 filelist fileListR Z[Z I  D I��\��
�� .corecnte****       ****\ 1   D E��
�� 
rslt��  [ ]^] r   J M_`_ 1   J K��
�� 
rslt` o      ���� 0 numfiles numFiles^ aba l  N Ucdec n   N Ufgf I   O U��h����  0 prepareprogbar prepareProgBarh iji o   O P���� 0 numfiles numFilesj k��k m   P Q���� ��  ��  g  f   N Od   Prepare Progress Bar   e �ll *   P r e p a r e   P r o g r e s s   B a rb mnm l  V \opqo n   V \rsr I   W \��t���� 0 fadeinprogbar fadeinProgBart u��u m   W X���� ��  ��  s  f   V Wp 2 , Open the desired Progress Bar window style.   q �vv X   O p e n   t h e   d e s i r e d   P r o g r e s s   B a r   w i n d o w   s t y l e .n wxw l  ] ]��yz��  y F @ rename prefixes within files  and file names of project files     z �{{ �   r e n a m e   p r e f i x e s   w i t h i n   f i l e s     a n d   f i l e   n a m e s   o f   p r o j e c t   f i l e s    x |}| Y   ]~�����~ l  g���� k   g�� ��� l  g o���� n   g o��� I   h o������� $0 incrementprogbar incrementProgBar� ��� o   h i���� 0 n  � ��� o   i j���� 0 numfiles numFiles� ���� m   j k���� ��  ��  �  f   g h� !  Increment the progress bar   � ��� 6   I n c r e m e n t   t h e   p r o g r e s s   b a r� ��� l  p w���� r   p w��� l  p u������ e   p u�� n   p u��� 4   q t���
�� 
cobj� o   r s���� 0 n  � o   p q���� 0 filelist fileList��  ��  � o      ���� 0 currentfile currentFile� #  Get the next file to process   � ��� :   G e t   t h e   n e x t   f i l e   t o   p r o c e s s� ��� l  x ����� r   x ���� b   x ���� l  x {����� c   x {��� o   x y�~�~ 0 	thefolder 	theFolder� m   y z�}
�} 
ctxt��  �  � l  { ��|�{� n   { ��� 4   | �z�
�z 
cobj� o   } ~�y�y 0 n  � o   { |�x�x 0 filelist fileList�|  �{  � o      �w�w &0 pathtocurrentfile pathToCurrentFile� #  Get the next file to process   � ��� :   G e t   t h e   n e x t   f i l e   t o   p r o c e s s� ��v� Z   ����u�� C   � ���� o   � ��t�t 0 currentfile currentFile� o   � ��s�s 0 
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
docf� o  de���� 0 currentfile currentFile� o  `a���� 0 	thefolder 	theFolder��      property list for project    ��� 4   p r o p e r t y   l i s t   f o r   p r o j e c t��  �L   , & old project name includes old prefix     ��� L   o l d   p r o j e c t   n a m e   i n c l u d e s   o l d   p r e f i x  � ���� l nn��������  ��  ��  ��  � , & If its name has got the old prefix...   � ��� L   I f   i t s   n a m e   h a s   g o t   t h e   o l d   p r e f i x . . .�u  � l r���� Z  r������ D  rw��� o  rs���� 0 currentfile currentFile� m  sv�� ���  . x c o d e p r o j� l z����� r  z���� b  z��� o  z{����  0 newprojectname newProjectName� m  {~�� ���  . x c o d e p r o j� n      ��� 1  ����
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
docf2 o  �[�[ 0 currentfile currentFile1 o  �Z�Z 0 	thefolder 	theFolder&   should only happen once	   ' �33 2   s h o u l d   o n l y   h a p p e n   o n c e 	�_  �m  �n  � 454 =  )0676 o  )*�Y�Y 0 currentfile currentFile7 b  */898 o  *+�X�X  0 oldprojectname oldProjectName9 m  +.:: �;;  . n i b5 <=< r  3H>?> b  38@A@ o  34�W�W  0 newprojectname newProjectNameA m  47BB �CC  . n i b? n      DED 1  EG�V
�V 
pnamE n  8EFGF 4  @E�UH
�U 
docfH o  CD�T�T 0 currentfile currentFileG n  8@IJI 4  9@�SK
�S 
cfolK o  :?�R�R 0 	nibfolder 	nibFolderJ o  89�Q�Q 0 	thefolder 	theFolder= LML =  KRNON o  KL�P�P 0 currentfile currentFileO b  LQPQP o  LM�O�O  0 oldprojectname oldProjectNameQ m  MPRR �SS  . x i bM TUT k  UxVV WXW n UbYZY I  Vb�N[�M�N &0 replacetextinfile replaceTextInFile[ \]\ c  VY^_^ o  VW�L�L 0 	thefolder 	theFolder_ m  WX�K
�K 
ctxt] `a` o  YZ�J�J 0 currentfile currentFilea bcb o  Z[�I�I  0 oldprojectname oldProjectNamec ded o  [\�H�H  0 newprojectname newProjectNamee fgf o  \]�G�G 0 
old_prefix  g h�Fh o  ]^�E�E 0 
new_prefix  �F  �M  Z  f  UVX i�Di r  cxjkj b  chlml o  cd�C�C  0 newprojectname newProjectNamem m  dgnn �oo  . x i bk n      pqp 1  uw�B
�B 
pnamq n  hursr 4  pu�At
�A 
docft o  st�@�@ 0 currentfile currentFiles n  hpuvu 4  ip�?w
�? 
cfolw o  jo�>�> 0 	xibfolder 	xibFolderv o  hi�=�= 0 	thefolder 	theFolder�D  U xyx D  {�z{z o  {|�<�< 0 currentfile currentFile{ m  ||| �}}  . p l i s ty ~�;~ k  � ��� r  ����� m  ���� ���  . p l i s t� o      �:�: 0 
filesuffix 
fileSuffix� ��� n ����� I  ���9��8�9 &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ���7�7 0 	thefolder 	theFolder� m  ���6
�6 
ctxt� ��� o  ���5�5 0 currentfile currentFile� ��� o  ���4�4  0 oldprojectname oldProjectName� ��� o  ���3�3  0 newprojectname newProjectName� ��� o  ���2�2 0 
old_prefix  � ��1� o  ���0�0 0 
new_prefix  �1  �8  �  f  ��� ��� r  ����� I ���/��.
�/ .sysoctonshor       TEXT� l ����-�,� n  ����� 4 ���+�
�+ 
cobj� m  ���*�* � o  ���)�)  0 oldprojectname oldProjectName�-  �,  �.  � o      �(�( 0 testchar testChar� ��� Z  �����'�&� F  ����� @  ����� o  ���%�% 0 testchar testChar� m  ���$�$ A� B  ����� o  ���#�# 0 testchar testChar� m  ���"�" Z� l ������ k  ���� ��� r  ����� m  ���� ���  � o      �!�! 
0 locase  � ��� Y  ���� ���� r  ����� b  ����� o  ���� 
0 locase  � l ������ n  ����� 4  ����
� 
cobj� o  ���� 0 n  � o  ����  0 oldprojectname oldProjectName�  �  � o      �� 
0 locase  �  0 n  � m  ���� � l ������ I �����
� .corecnte****       ****� o  ����  0 oldprojectname oldProjectName�  �  �  �  � ��� r  ����� b  ����� l ������ I �����
� .sysontocTEXT       shor� l ������ [  ����� o  ���
�
 0 testchar testChar� m  ���	�	  �  �  �  �  �  � o  ���� 
0 locase  � o      �� 
0 locase  �  �   is it uppercase ?   � ��� $   i s   i t   u p p e r c a s e   ?�'  �&  � ��� l ������ n ����� I  ������ &0 simplereplacetext simpleReplaceText� ��� o  ���� 0 currentfile currentFile� ��� o  ���� 
0 locase  � ��� o  ����  0 newprojectname newProjectName�  �  �  f  ��� 7 1 catch any lowercase instances of project name 		   � ��� b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 	� ��� l ��� ���   � ; 5 rename only .plist files containing the projectname    � ��� j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  � ���� r  ���� l ������� I ������� 0 searchreplace searchReplace�  f  ��� ����
�� 
into� o  ������ 0 currentfile currentFile� ����
�� 
at  � o  � ����  0 oldprojectname oldProjectName� ������� 0 replacestring replaceString� o  ����  0 newprojectname newProjectName��  ��  ��  � n      ��� 1  ��
�� 
pnam� n  ��� 4  	���
�� 
docf� o  ���� 0 currentfile currentFile� o  	���� 0 	thefolder 	theFolder��  �;  ��  � F @ project files that don't include prefix also need to be updated   � ��� �   p r o j e c t   f i l e s   t h a t   d o n ' t   i n c l u d e   p r e f i x   a l s o   n e e d   t o   b e   u p d a t e d�v  �   Do all files   � ���    D o   a l l   f i l e s�� 0 n   m   ` a���� � o   a b���� 0 numfiles numFiles��  } ���� l ��������  ��  ��  ��  O m   7 8���                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  ��   � ��� l     ��������  ��  ��  � ��� l     ������  � J D subroutine to replace old file names and prefixes with the new ones   � ��� �   s u b r o u t i n e   t o   r e p l a c e   o l d   f i l e   n a m e s   a n d   p r e f i x e s   w i t h   t h e   n e w   o n e s� ��� i   � � I      ������ &0 replacetextinfile replaceTextInFile  o      ���� 0 	thefolder 	theFolder  o      ���� 0 thefile theFile  o      ���� 0 oldtext1   	 o      ���� 0 newtext1  	 

 o      ���� 0 oldtext2   �� o      ���� 0 newtext2  ��  ��    k    P  r      m      �  m y t e m p . h o      ���� 0 tempfile tempFile  r     c    	 n     1    ��
�� 
psxp o    ���� 0 	thefolder 	theFolder m    ��
�� 
TEXT o      ���� 0 myfolderpath myFolderPath  l   ����     Create a script for sed    �   0   C r e a t e   a   s c r i p t   f o r   s e d !"! r    #$# b    %&% o    ���� 0 myfolderpath myFolderPath& o    ���� &0 replacescriptname replaceScriptName$ o      ���� 0 filename fileName" '(' r    ")*) I    ��+,
�� .rdwropenshor       file+ 4    ��-
�� 
psxf- o    ���� 0 filename fileName, ��.��
�� 
perm. m    ��
�� boovtrue��  * o      ���� 0 fileid fileID( /0/ I  # Z��12
�� .rdwrwritnull���     ****1 b   # R343 b   # N565 b   # H787 b   # F9:9 b   # D;<; b   # B=>= b   # @?@? b   # >ABA b   # 8CDC b   # 6EFE b   # 4GHG b   # 2IJI b   # ,KLK b   # *MNM b   # (OPO b   # &QRQ m   # $SS �TT $ s / \ ( [ ^ a - j l - z A - Z ] \ )R o   $ %���� 0 oldtext2  P m   & 'UU �VV  / \ 1N o   ( )���� 0 newtext2  L m   * +WW �XX  / gJ l  , 1Y����Y I  , 1��Z��
�� .sysontocTEXT       shorZ m   , -���� 
��  ��  ��  H m   2 3[[ �\\  / ^F o   4 5���� 0 oldtext2  D m   6 7]] �^^  / {  B l  8 =_����_ I  8 =��`��
�� .sysontocTEXT       shor` m   8 9���� 
��  ��  ��  @ m   > ?aa �bb  s /> o   @ A���� 0 oldtext2  < m   B Ccc �dd  /: o   D E���� 0 newtext2  8 m   F Gee �ff  / 16 l  H Mg����g I  H M��h��
�� .sysontocTEXT       shorh m   H I���� 
��  ��  ��  4 m   N Qii �jj  }2 ��k��
�� 
refnk o   U V���� 0 fileid fileID��  0 lml I  [ `��n��
�� .rdwrclosnull���     ****n o   [ \���� 0 fileid fileID��  m opo l  a a��qr��  q  end if   r �ss  e n d   i fp tut r   a hvwv c   a fxyx n   a dz{z 1   b d��
�� 
psxp{ o   a b���� 0 	thefolder 	theFoldery m   d e��
�� 
TEXTw o      ���� 0 	shellpath 	ShellPathu |}| l  i �~�~ r   i ���� l  i ������� I  i �������� 0 searchreplace searchReplace��  � ����
�� 
into� o   m n���� 0 	shellpath 	ShellPath� ����
�� 
at  � l  q t������ m   q t�� ���   ��  ��  � ������� 0 replacestring replaceString� m   w z�� ���  \ %��  ��  ��  � o      ���� 0 	shellpath 	ShellPath H B uses global variable to overcome POSIX issue with spaces in names   � ��� �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s} ��� r   � ���� l  � ������� I  � �������� 0 searchreplace searchReplace��  � ����
�� 
into� o   � ����� 0 	shellpath 	ShellPath� ����
�� 
at  � m   � ��� ���  %� ������� 0 replacestring replaceString� m   � ��� ���   ��  ��  ��  � o      ���� 0 	shellpath 	ShellPath� ��� l  � �������  � 7 1 replace occurences of oldProject with newProject   � ��� b   r e p l a c e   o c c u r e n c e s   o f   o l d P r o j e c t   w i t h   n e w P r o j e c t� ��� r   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� m   � ��� ��� 
 c a t    � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� m   � ��� ���    ;  � m   � ��� ���      >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    ;  � m   � ��� ���    s e d   - e   ' s /� o   � ����� 0 oldtext1  � m   � ��� ���  /� o   � ����� 0 newtext1  � m   � ��� ���  / g '  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� m   � ��� ���    >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    ;  � m   � ��� ���    >� o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� o      ���� 0 cmd  � ��� I  � ������
�� .sysoexecTEXT���     TEXT� o   � ����� 0 cmd  ��  � ��� l  � �������  � 5 / replace occurences of oldPrefix with newPrefix   � ��� ^   r e p l a c e   o c c u r e n c e s   o f   o l d P r e f i x   w i t h   n e w P r e f i x� ��� r   �6��� b   �4��� b   �2��� b   �0��� b   �,   b   �( b   �& b   �$ b   � 	 b   �

 b   � b   � b   � b   � b   � b   � b   � b   � b   �  b   � � b   � � !  b   � �"#" b   � �$%$ b   � �&'& m   � �(( �))  c a t  ' o   � ����� 0 	shellpath 	ShellPath% o   � ����� 0 thefile theFile# m   � �** �++    >  ! o   � ����� 0 	shellpath 	ShellPath o   � ����� 0 tempfile tempFile m   � �,, �--    ;   m   .. �//    >   o  �� 0 	shellpath 	ShellPath o  �~�~ 0 thefile theFile m  00 �11    ;   m  22 �33    s e d   - f   o  �}�} 0 	shellpath 	ShellPath o  �|�| &0 replacescriptname replaceScriptName m  44 �55    o  �{�{ 0 	shellpath 	ShellPath	 o  �z�z 0 tempfile tempFile m   #66 �77    >   o  $%�y�y 0 	shellpath 	ShellPath o  &'�x�x 0 thefile theFile m  (+88 �99    ;  � m  ,/:: �;;    r m   - f  � o  01�w�w 0 	shellpath 	ShellPath� o  23�v�v 0 tempfile tempFile� o      �u�u 0 cmd  � <=< I 7<�t>�s
�t .sysoexecTEXT���     TEXT> o  78�r�r 0 cmd  �s  = ?@? l ==�qAB�q  A   delete the temp file   B �CC *   d e l e t e   t h e   t e m p   f i l e@ DED l =JFGHF r  =JIJI b  =HKLK b  =BMNM m  =@OO �PP  r m  N o  @A�p�p 0 	shellpath 	ShellPathL o  BG�o�o &0 replacescriptname replaceScriptNameJ o      �n�n 0 cmd  G 5 / remove sed script file from new project folder   H �QQ ^   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e rE R�mR I KP�lS�k
�l .sysoexecTEXT���     TEXTS o  KL�j�j 0 cmd  �k  �m  � TUT l     �i�h�g�i  �h  �g  U VWV l     �fXY�f  X U O simple form of replaceTextinFile subroutine to handle plist and project files    Y �ZZ �   s i m p l e   f o r m   o f   r e p l a c e T e x t i n F i l e   s u b r o u t i n e   t o   h a n d l e   p l i s t   a n d   p r o j e c t   f i l e s  W [\[ i    ]^] I      �e_�d�e &0 simplereplacetext simpleReplaceText_ `a` o      �c�c 0 thefile theFilea bcb o      �b�b 0 oldtext  c d�ad o      �`�` 0 newtext newText�a  �d  ^ k     _ee fgf l    hijh r     klk c     	mnm b     opo m     qq �rr  t e m pp o    �_�_ 0 
filesuffix 
fileSuffixn m    �^
�^ 
TEXTl o      �]�] 0 tempfile tempFilei %  use global variable fileSuffix   j �ss >   u s e   g l o b a l   v a r i a b l e   f i l e S u f f i xg tut l   vwxv r    yzy l   {�\�[{ I   �Z�Y|�Z 0 searchreplace searchReplace�Y  | �X}~
�X 
into} o    �W�W 0 mypath myPath~ �V�
�V 
at   l   ��U�T� m    �� ���   �U  �T  � �S��R�S 0 replacestring replaceString� m    �� ���  \ %�R  �\  �[  z o      �Q�Q 0 	shellpath 	ShellPathw H B uses global variable to overcome POSIX issue with spaces in names   x ��� �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e su ��� r    +��� l   )��P�O� I   )�N�M��N 0 searchreplace searchReplace�M  � �L��
�L 
into� o     !�K�K 0 	shellpath 	ShellPath� �J��
�J 
at  � m   " #�� ���  %� �I��H�I 0 replacestring replaceString� m   $ %�� ���   �H  �P  �O  � o      �G�G 0 	shellpath 	ShellPath� ��� l  , Y���� r   , Y��� b   , W��� b   , U��� b   , Q��� b   , O��� b   , K��� b   , I��� b   , E��� b   , C��� b   , ?��� b   , =��� b   , ;��� b   , 9��� b   , 7��� b   , 5��� b   , 3��� b   , 1��� b   , /��� m   , -�� ���  b a s h ;   c d  � o   - .�F�F 0 	shellpath 	ShellPath� m   / 0�� ���  ;   c a t  � o   1 2�E�E 0 thefile theFile� m   3 4�� ���    >  � o   5 6�D�D 0 tempfile tempFile� m   7 8�� ���  ;   >� o   9 :�C�C 0 thefile theFile� m   ; <�� ���  ;   s e d   - e   ' s /� o   = >�B�B 0 oldtext  � m   ? B�� ���  /� o   C D�A�A 0 newtext newText� m   E H�� ���  / g '  � o   I J�@�@ 0 tempfile tempFile� m   K N�� ���    >  � o   O P�?�? 0 thefile theFile� m   Q T�� ���  ;   r m   - f  � o   U V�>�> 0 tempfile tempFile� o      �=�= 0 cmd  �   and clean up!   � ���    a n d   c l e a n   u p !� ��<� I  Z _�;��:
�; .sysoexecTEXT���     TEXT� o   Z [�9�9 0 cmd  �:  �<  \ ��� l     �8�7�6�8  �7  �6  � ��� l     �5���5  � j d universal search and replace subroutine -- operates strictly in AppleScript on a string or document   � ��� �   u n i v e r s a l   s e a r c h   a n d   r e p l a c e   s u b r o u t i n e   - -   o p e r a t e s   s t r i c t l y   i n   A p p l e S c r i p t   o n   a   s t r i n g   o r   d o c u m e n t� ��� i   ! $��� I      �4�3��4 0 searchreplace searchReplace�3  � �2��
�2 
into� o      �1�1 0 
mainstring 
mainString� �0��
�0 
at  � o      �/�/ 0 searchstring searchString� �.��-�. 0 replacestring replaceString� o      �,�, 0 replacestring replaceString�-  � k     S�� ��� V     P��� l   K���� k    K�� ��� l   �+���+  � v p we use offset command here to derive the position within the document where the search string first appears       � ��� �   w e   u s e   o f f s e t   c o m m a n d   h e r e   t o   d e r i v e   t h e   p o s i t i o n   w i t h i n   t h e   d o c u m e n t   w h e r e   t h e   s e a r c h   s t r i n g   f i r s t   a p p e a r s        � ��� r    ��� I   �*�)�
�* .sysooffslong    ��� null�)  � �(��
�( 
psof� o   
 �'�' 0 searchstring searchString� �&��%
�& 
psin� o    �$�$ 0 
mainstring 
mainString�%  � o      �#�# 0 foundoffset foundOffset� ��� l   �"���"  � � � begin assembling remade string by getting all text up to the search location, minus the first character of the search string      � �      b e g i n   a s s e m b l i n g   r e m a d e   s t r i n g   b y   g e t t i n g   a l l   t e x t   u p   t o   t h e   s e a r c h   l o c a t i o n ,   m i n u s   t h e   f i r s t   c h a r a c t e r   o f   t h e   s e a r c h   s t r i n g      �  Z    /�! =    o    � �  0 foundoffset foundOffset m    ��  l   	
 r     m     �   o      �� 0 stringstart stringStart	 \ V search string starts at beginning, most likely to occur when searching a small string   
 � �   s e a r c h   s t r i n g   s t a r t s   a t   b e g i n n i n g ,   m o s t   l i k e l y   t o   o c c u r   w h e n   s e a r c h i n g   a   s m a l l   s t r i n g�!   r     / n     - 7  ! -�
� 
ctxt m   % '��  l  ( ,�� \   ( , o   ) *�� 0 foundoffset foundOffset m   * +�� �  �   o     !�� 0 
mainstring 
mainString o      �� 0 stringstart stringStart  l  0 0��   / ) get the end part of the remade string       � R   g e t   t h e   e n d   p a r t   o f   t h e   r e m a d e   s t r i n g        r   0 C !  n   0 A"#" 7  1 A�$%
� 
ctxt$ l  5 =&��& [   5 ='(' o   6 7�� 0 foundoffset foundOffset( l  7 <)��) I  7 <�*�
� .corecnte****       ***** o   7 8�� 0 searchstring searchString�  �  �  �  �  % m   > @����# o   0 1�
�
 0 
mainstring 
mainString! o      �	�	 0 	stringend 	stringEnd +,+ l  D D�-.�  - C = remake mainString to start, replace string and end string      . �// z   r e m a k e   m a i n S t r i n g   t o   s t a r t ,   r e p l a c e   s t r i n g   a n d   e n d   s t r i n g      , 0�0 r   D K121 b   D I343 b   D G565 o   D E�� 0 stringstart stringStart6 o   E F�� 0 replacestring replaceString4 o   G H�� 0 	stringend 	stringEnd2 o      �� 0 
mainstring 
mainString�  � 6 0 will not do anything if search string not found   � �77 `   w i l l   n o t   d o   a n y t h i n g   i f   s e a r c h   s t r i n g   n o t   f o u n d� E    898 o    �� 0 
mainstring 
mainString9 o    �� 0 searchstring searchString� :� : l  Q S;<=; L   Q S>> o   Q R���� 0 
mainstring 
mainString< "  ship it back to the caller    = �?? 8   s h i p   i t   b a c k   t o   t h e   c a l l e r  �   � @A@ l     ��������  ��  ��  A BCB i  % (DED I      ��F���� 0 upcase upCaseF G��G o      ���� 0 astring aString��  ��  E k     PHH IJI r     KLK m     MM �NN  L o      ���� 
0 buffer  J OPO Y    MQ��RS��Q k    HTT UVU r    WXW l   Y����Y I   ��Z��
�� .sysoctonshor       TEXTZ n    [\[ 4    ��]
�� 
cobj] o    ���� 0 i  \ o    ���� 0 astring aString��  ��  ��  X o      ���� 0 testchar testCharV ^_^ l   ��������  ��  ��  _ `a` Z    Fbc��db F    (efe @     ghg o    ���� 0 testchar testCharh m    ���� af B   # &iji o   # $���� 0 testchar testCharj m   $ %���� zc k   + 8kk lml l  + +��no��  n D > if lowercase ascii character then change to uppercase version   o �pp |   i f   l o w e r c a s e   a s c i i   c h a r a c t e r   t h e n   c h a n g e   t o   u p p e r c a s e   v e r s i o nm qrq r   + 6sts b   + 4uvu o   + ,���� 
0 buffer  v l  , 3w����w I  , 3��x��
�� .sysontocTEXT       shorx l  , /y����y \   , /z{z o   , -���� 0 testchar testChar{ m   - .����  ��  ��  ��  ��  ��  t o      ���� 
0 buffer  r |��| l  7 7��������  ��  ��  ��  ��  d k   ; F}} ~~ l  ; ;������  �   do not chage character   � ��� .   d o   n o t   c h a g e   c h a r a c t e r ��� r   ; D��� b   ; B��� o   ; <���� 
0 buffer  � l  < A������ I  < A�����
�� .sysontocTEXT       shor� l  < =������ o   < =���� 0 testchar testChar��  ��  ��  ��  ��  � o      ���� 
0 buffer  � ���� l  E E��������  ��  ��  ��  a ���� l  G G��������  ��  ��  ��  �� 0 i  R m    ���� S I   �����
�� .corecnte****       ****� o    	���� 0 astring aString��  ��  P ��� l  N N��������  ��  ��  � ���� L   N P�� o   N O���� 
0 buffer  ��  C ��� l     ��������  ��  ��  � ��� l     ������  �   T.J. Mahaffey | 9.9.2004   � ��� 2   T . J .   M a h a f f e y   |   9 . 9 . 2 0 0 4� ��� l     ������  �   1951FDG | 8.4.2011   � ��� &   1 9 5 1 F D G   |   8 . 4 . 2 0 1 1� ��� l     ������  � � � The code contained herein is free. Re-use at will, but please include a web bookmark or weblocation file to my website if you do.   � ���   T h e   c o d e   c o n t a i n e d   h e r e i n   i s   f r e e .   R e - u s e   a t   w i l l ,   b u t   p l e a s e   i n c l u d e   a   w e b   b o o k m a r k   o r   w e b l o c a t i o n   f i l e   t o   m y   w e b s i t e   i f   y o u   d o .� ��� l     ������  � ; 5 Or simply some kind of acknowledgement in your code.   � ��� j   O r   s i m p l y   s o m e   k i n d   o f   a c k n o w l e d g e m e n t   i n   y o u r   c o d e .� ��� l     ��������  ��  ��  � ��� l     ������  � ' ! Prepare progress bar subroutine.   � ��� B   P r e p a r e   p r o g r e s s   b a r   s u b r o u t i n e .� ��� i   ) ,��� I      �������  0 prepareprogbar prepareProgBar� ��� o      ���� 0 somemaxcount someMaxCount� ���� o      ���� 0 
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
minW� n   F M   4   J M��
�� 
proI m   K L����  4   F J��
�� 
cwin o   H I���� 0 
windowname 
windowName� �� r   S ` o   S T���� 0 somemaxcount someMaxCount n       1   [ _��
�� 
maxV n   T [	
	 4   X [��
�� 
proI m   Y Z�� 
 4   T X�~
�~ 
cwin o   V W�}�} 0 
windowname 
windowName��  � m     �                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  �  l     �|�{�z�|  �{  �z    l     �y�y   ) # Increment progress bar subroutine.    � F   I n c r e m e n t   p r o g r e s s   b a r   s u b r o u t i n e .  i   - 0 I      �x�w�x $0 incrementprogbar incrementProgBar  o      �v�v 0 
itemnumber 
itemNumber  o      �u�u 0 somemaxcount someMaxCount �t o      �s�s 0 
windowname 
windowName�t  �w   O     &  k    %!! "#" r    $%$ b    &'& b    ()( b    *+* b    	,-, b    ./. m    00 �11  P r o c e s s i n g  / o    �r�r 0 
itemnumber 
itemNumber- m    22 �33    o f  + o   	 
�q�q 0 somemaxcount someMaxCount) m    44 �55    -  ' l   6�p�o6 n    787 4    �n9
�n 
cobj9 o    �m�m 0 
itemnumber 
itemNumber8 o    �l�l 0 filelist fileList�p  �o  % n      :;: 1    �k
�k 
titl; 4    �j<
�j 
cwin< o    �i�i 0 
windowname 
windowName# =�h= r    %>?> o    �g�g 0 
itemnumber 
itemNumber? n      @A@ 1   " $�f
�f 
conTA n    "BCB 4    "�eD
�e 
proID m     !�d�d C 4    �cE
�c 
cwinE o    �b�b 0 
windowname 
windowName�h    m     FF�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��   GHG l     �a�`�_�a  �`  �_  H IJI l     �^KL�^  K %  Fade in a progress bar window.   L �MM >   F a d e   i n   a   p r o g r e s s   b a r   w i n d o w .J NON i   1 4PQP I      �]R�\�] 0 fadeinprogbar fadeinProgBarR S�[S o      �Z�Z 0 
windowname 
windowName�[  �\  Q O     OTUT k    NVV WXW I   �YY�X
�Y .appScentnull���    obj Y 4    �WZ
�W 
cwinZ o    �V�V 0 
windowname 
windowName�X  X [\[ r    ]^] m    �U�U  ^ n      _`_ 1    �T
�T 
alpV` 4    �Sa
�S 
cwina o    �R�R 0 
windowname 
windowName\ bcb r    ded m    �Q
�Q boovtruee n      fgf 1    �P
�P 
pvisg 4    �Oh
�O 
cwinh o    �N�N 0 
windowname 
windowNamec iji r    "klk m     mm ?�������l o      �M�M 0 	fadevalue 	fadeValuej non Y   # @p�Lqr�Kp k   - ;ss tut r   - 5vwv o   - .�J�J 0 	fadevalue 	fadeValuew n      xyx 1   2 4�I
�I 
alpVy 4   . 2�Hz
�H 
cwinz o   0 1�G�G 0 
windowname 
windowNameu {�F{ r   6 ;|}| [   6 9~~ o   6 7�E�E 0 	fadevalue 	fadeValue m   7 8�� ?�������} o      �D�D 0 	fadevalue 	fadeValue�F  �L 0 i  q m   & '�C�C  r m   ' (�B�B 	�K  o ��A� I  A N�@��
�@ .coVSstaAnull���    obj � n   A H��� 4   E H�?�
�? 
proI� m   F G�>�> � 4   A E�=�
�= 
cwin� o   C D�<�< 0 
windowname 
windowName� �;��:
�; 
usTA� m   I J�9
�9 boovtrue�:  �A  U m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  O ��� l     �8�7�6�8  �7  �6  � ��� l     �5���5  � &   Fade out a progress bar window.   � ��� @   F a d e   o u t   a   p r o g r e s s   b a r   w i n d o w .� ��� i   5 8��� I      �4��3�4  0 fadeoutprogbar fadeoutProgBar� ��2� o      �1�1 0 
windowname 
windowName�2  �3  � O     =��� k    <�� ��� I   �0��
�0 .coVSstoTnull���    obj � n    ��� 4    �/�
�/ 
proI� m   	 
�.�. � 4    �-�
�- 
cwin� o    �,�, 0 
windowname 
windowName� �+��*
�+ 
usTA� m    �)
�) boovtrue�*  � ��� r    ��� m    �� ?�������� o      �(�( 0 	fadevalue 	fadeValue� ��� Y    3��'���&� k     .�� ��� r     (��� o     !�%�% 0 	fadevalue 	fadeValue� n      ��� 1   % '�$
�$ 
alpV� 4   ! %�#�
�# 
cwin� o   # $�"�" 0 
windowname 
windowName� ��!� r   ) .��� \   ) ,��� o   ) *� �  0 	fadevalue 	fadeValue� m   * +�� ?�������� o      �� 0 	fadevalue 	fadeValue�!  �' 0 i  � m    �� � m    �� 	�&  � ��� r   4 <��� m   4 5�
� boovfals� n      ��� 1   9 ;�
� 
pvis� 4   5 9��
� 
cwin� o   7 8�� 0 
windowname 
windowName�  � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  � ��� l     ����  �  �  � ��� l     ����  �    Show progress bar window.   � ��� 4   S h o w   p r o g r e s s   b a r   w i n d o w .� ��� i   9 <��� I      ���� 0 showprogbar showProgBar� ��� o      �� 0 
windowname 
windowName�  �  � O     $��� k    #�� ��� I   ���
� .appScentnull���    obj � 4    ��
� 
cwin� o    �� 0 
windowname 
windowName�  � ��� r    ��� m    �
� boovtrue� n      ��� 1    �

�
 
pvis� 4    �	�
�	 
cwin� o    �� 0 
windowname 
windowName� ��� I   #���
� .coVSstaAnull���    obj � n    ��� 4    ��
� 
proI� m    �� � 4    ��
� 
cwin� o    �� 0 
windowname 
windowName� ��� 
� 
usTA� m    ��
�� boovtrue�   �  � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �    Hide progress bar window.   � ��� 4   H i d e   p r o g r e s s   b a r   w i n d o w .� ��� i   = @��� I      ������� 0 hideprogbar hideProgBar� ���� o      ���� 0 
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
�� boovtrue��  � ���� r    	 		  m    ��
�� boovfals	 n      			 1    ��
�� 
pvis	 4    ��	
�� 
cwin	 o    ���� 0 
windowname 
windowName��  � m     		�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  � 			 l     ��������  ��  ��  	 				 l     ��	
	��  	
 7 1 Enable 'barber pole' behavior of a progress bar.   	 �		 b   E n a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .		 			 i   A D			 I      ��	���� 0 
barberpole 
barberPole	 	��	 o      ���� 0 
windowname 
windowName��  ��  	 O     			 r    			 m    ��
�� boovtrue	 n      			 1    ��
�� 
indR	 n    			 4   	 ��	
�� 
proI	 m   
 ���� 	 4    	��	
�� 
cwin	 o    ���� 0 
windowname 
windowName	 m     		�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	 			 l     ��������  ��  ��  	 	 	!	  l     ��	"	#��  	" 8 2 Disable 'barber pole' behavior of a progress bar.   	# �	$	$ d   D i s a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .	! 	%	&	% i   E H	'	(	' I      ��	)����  0 killbarberpole killBarberPole	) 	*��	* o      ���� 0 
windowname 
windowName��  ��  	( O     	+	,	+ r    	-	.	- m    ��
�� boovfals	. n      	/	0	/ 1    ��
�� 
indR	0 n    	1	2	1 4   	 ��	3
�� 
proI	3 m   
 ���� 	2 4    	��	4
�� 
cwin	4 o    ���� 0 
windowname 
windowName	, m     	5	5�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	& 	6	7	6 l     ��������  ��  ��  	7 	8	9	8 l     ��	:	;��  	:   Launch ProgBar.   	; �	<	<     L a u n c h   P r o g B a r .	9 	=	>	= i   I L	?	@	? I      �������� 0 startprogbar startProgBar��  ��  	@ O     
	A	B	A I   	������
�� .ascrnoop****      � ****��  ��  	B m     	C	C�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	> 	D	E	D l     ��������  ��  ��  	E 	F	G	F l     ��	H	I��  	H   Quit ProgBar.   	I �	J	J    Q u i t   P r o g B a r .	G 	K	L	K i   M P	M	N	M I      �������� 0 stopprogbar stopProgBar��  ��  	N O     
	O	P	O I   	������
�� .aevtquitnull��� ��� null��  ��  	P m     	Q	Q�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.1   ;/:Documents:Lablib:Utilities:Clone Project 3.1:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.1/ProgBar.app  / ��  	L 	R	S	R l     ��������  ��  ��  	S 	T	U	T l     ��	V	W��  	V  ////////////  User input   	W �	X	X 0 / / / / / / / / / / / /     U s e r   i n p u t	U 	Y	Z	Y l     ��������  ��  ��  	Z 	[	\	[ l   #	]	^	_	] r    #	`	a	` m    	b	b �	c	c  R E S U B M I T	a o      ���� 0 buttonpressed buttonPressed	^   at least try one time   	_ �	d	d ,   a t   l e a s t   t r y   o n e   t i m e	\ 	e	f	e l  $�	g����	g V   $�	h	i	h k   0�	j	j 	k	l	k l  0 0��	m	n��  	m + %  User chooses project folder to copy   	n �	o	o J     U s e r   c h o o s e s   p r o j e c t   f o l d e r   t o   c o p y	l 	p	q	p r   0 C	r	s	r c   0 ?	t	u	t l  0 ;	v����	v I  0 ;����	w
�� .sysostflalis    ��� null��  	w ��	x��
�� 
prmp	x m   4 7	y	y �	z	z h T o   d u p l i c a t e :   c h o o s e   P l u g i n   p r o j e c t   t o   u s e   a s   s o u r c e��  ��  ��  	u m   ; >��
�� 
alis	s o      ���� 0 	thefolder 	theFolder	q 	{	|	{ r   D U	}	~	} n   D O		�	 1   K O��
�� 
pnam	� l  D K	�����	� I  D K��	���
�� .sysonfo4asfe        file	� o   D G���� 0 	thefolder 	theFolder��  ��  ��  	~ o      ����  0 oldprojectname oldProjectName	| 	�	�	� l  V V��������  ��  ��  	� 	�	�	� l  V V��	�	���  	� s m this extracts the path to folder in which the duplicated project folder resides and gives it the name myHome   	� �	�	� �   t h i s   e x t r a c t s   t h e   p a t h   t o   f o l d e r   i n   w h i c h   t h e   d u p l i c a t e d   p r o j e c t   f o l d e r   r e s i d e s   a n d   g i v e s   i t   t h e   n a m e   m y H o m e	� 	�	�	� l  V V��	�	���  	� 1 + POSIX format because used by shell scripts   	� �	�	� V   P O S I X   f o r m a t   b e c a u s e   u s e d   b y   s h e l l   s c r i p t s	� 	�	�	� Q   V �	�	�	�	� k   Y �	�	� 	�	�	� r   Y d	�	�	� n  Y `	�	�	� 1   \ `��
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
TEXT��  ��  	� m   � �	�	� �	�	�  /	� o      ���� 0 myhome myHome	� 	��	� r   � �	�	�	� o   � ��~�~ 0 olddelimiter oldDelimiter	� n     	�	�	� 1   � ��}
�} 
txdl	� 1   � ��|
�| 
ascr�  	� R      �{	��z
�{ .ascrerr ****      � ****	� m      	�	� �	�	� ~ e r r o r   o c c u r r e d   a t t e m p t i n g   t o   e x t r a c t   p a t h   t o   n e w   p r o j e c t   f o l d e r�z  	� r   � �	�	�	� o   � ��y�y 0 olddelimiter oldDelimiter	� n     	�	�	� 1   � ��x
�x 
txdl	� 1   � ��w
�w 
ascr	� 	�	�	� l  � ��v�u�t�v  �u  �t  	� 	�	�	� l  � ��s	�	��s  	� ? 9 User chooses the name they wish to give the project copy   	� �	�	� r   U s e r   c h o o s e s   t h e   n a m e   t h e y   w i s h   t o   g i v e   t h e   p r o j e c t   c o p y	� 	�	�	� I  � ��r	�	�
�r .sysodlogaskr        TEXT	� m   � �	�	� �	�	� & N a m e   o f   n e w   p l u g i n ?	� �q	�	�
�q 
dtxt	� m   � �	�	� �	�	�  n e w P l u g i n	� �p	�	�
�p 
btns	� J   � �	�	� 	��o	� m   � �	�	� �	�	�    O K�o  	� �n	��m
�n 
dflt	� m   � ��l�l �m  	� 	�	�	� s   �	�	�	� c   � �	�	�	� l  � �	��k�j	� 1   � ��i
�i 
rslt�k  �j  	� m   � ��h
�h 
list	� J      	�	� 	�	�	� o      �g�g 0 button_pressed  	� 	��f	� o      �e�e 0 text_returned  �f  	� 	�	�	� r   	�	�	� c  	�
 	� o  �d�d 0 text_returned  
  m  �c
�c 
TEXT	� o      �b�b  0 newprojectname newProjectName	� 


 l !>



 r  !>


 l !:
�a�`
 I !:�_�^
	�_ 0 searchreplace searchReplace�^  
	 �]



�] 
into

 o  %(�\�\  0 newprojectname newProjectName
 �[


�[ 
at  
 m  +.

 �

   
 �Z
�Y�Z 0 replacestring replaceString
 m  14

 �

  �Y  �a  �`  
 o      �X�X  0 newprojectname newProjectName
   remove all spaces   
 �

 $   r e m o v e   a l l   s p a c e s
 


 l ??�W�V�U�W  �V  �U  
 


 l ??�T�S�R�T  �S  �R  
 


 l ??�Q

�Q  
 ? 9 User provides the current prefix of the original project   
 �

 r   U s e r   p r o v i d e s   t h e   c u r r e n t   p r e f i x   o f   t h e   o r i g i n a l   p r o j e c t
 


 I ?d�P

 
�P .sysodlogaskr        TEXT
 l ?L
!�O�N
! b  ?L
"
#
" b  ?H
$
%
$ m  ?B
&
& �
'
' > W h a t   i s   t h e   c u r r e n t   p r e f i x   f o r  
% o  BG�M�M  0 oldprojectname oldProjectName
# m  HK
(
( �
)
)    ?�O  �N  
  �L
*
+
�L 
dtxt
* m  OR
,
, �
-
-  F T
+ �K
.
/
�K 
btns
. J  UZ
0
0 
1�J
1 m  UX
2
2 �
3
3  O K�J  
/ �I
4�H
�I 
dflt
4 m  ]^�G�G �H  
 
5
6
5 s  e�
7
8
7 c  el
9
:
9 l eh
;�F�E
; 1  eh�D
�D 
rslt�F  �E  
: m  hk�C
�C 
list
8 J      
<
< 
=
>
= o      �B�B 0 button_pressed  
> 
?�A
? o      �@�@ 0 text_returned  �A  
6 
@
A
@ r  ��
B
C
B c  ��
D
E
D o  ���?�? 0 text_returned  
E m  ���>
�> 
TEXT
C o      �=�= 0 
old_prefix  
A 
F
G
F l ��
H
I
J
H r  ��
K
L
K l ��
M�<�;
M I ���:�9
N�: 0 searchreplace searchReplace�9  
N �8
O
P
�8 
into
O o  ���7�7 0 
old_prefix  
P �6
Q
R
�6 
at  
Q m  ��
S
S �
T
T   
R �5
U�4�5 0 replacestring replaceString
U m  ��
V
V �
W
W  �4  �<  �;  
L o      �3�3 0 
old_prefix  
I   remove all spaces   
J �
X
X $   r e m o v e   a l l   s p a c e s
G 
Y
Z
Y r  ��
[
\
[ I  ���2
]�1�2 0 upcase upCase
] 
^�0
^ o  ���/�/ 0 
old_prefix  �0  �1  
\ o      �.�. 0 
old_prefix  
Z 
_
`
_ r  ��
a
b
a [  ��
c
d
c l ��
e�-�,
e I ���+
f�*
�+ .corecnte****       ****
f o  ���)�) 0 
old_prefix  �*  �-  �,  
d m  ���(�( 
b o      �'�' 0 kernel_beginning  
` 
g
h
g Z  ��
i
j�&�%
i E  ��
k
l
k o  ���$�$  0 myreservedlist myReservedList
l o  ���#�# 0 
old_prefix  
j k  ��
m
m 
n
o
n I ���"�!� 
�" .sysobeepnull��� ��� long�!  �   
o 
p
q
p I ���
r
s
� .sysodlogaskr        TEXT
r m  ��
t
t �
u
u W A R N I N G   - -   Y o u r   o r i g i n a l   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   T h e   p r o j e c t   i s   n o t   c l o n a b l e .   E x i t   n o w .
s �
v�
� 
disp
v m  ���
� stic    �  
q 
w�
w l ��
x
y
z
x L  ����  
y   abort program   
z �
{
{    a b o r t   p r o g r a m�  �&  �%  
h 
|
}
| l ������  �  �  
} 
~

~ l ���
�
��  
� 4 . User chooses new prefix to replace old prefix   
� �
�
� \   U s e r   c h o o s e s   n e w   p r e f i x   t o   r e p l a c e   o l d   p r e f i x
 
�
�
� T  ��
�
� k  ��
�
� 
�
�
� I ��
�
�
� .sysodlogaskr        TEXT
� l � 
���
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
� o  ����  0 newprojectname newProjectName
� m  ��
�
� �
�
�    ?  �  �  
� �
�
�
� 
dtxt
� m  
�
� �
�
�  
� �
�
�
� 
btns
� J  	
�
� 
��
� m  	
�
� �
�
�  O K�  
� �
��
� 
dflt
� m  �� �  
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
���

� 1  �	
�	 
rslt�  �
  
� m  �
� 
list
� J      
�
� 
�
�
� o      �� 0 button_pressed  
� 
��
� o      �� 0 text_returned  �  
� 
�
�
� r  :E
�
�
� c  :A
�
�
� o  :=�� 0 text_returned  
� m  =@�
� 
TEXT
� o      �� 0 
new_prefix  
� 
��
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
� m  IL� �  0
� o      ���� 0 n  
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
�����
� ?  Zs
�
�
� l Zq
�����
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
new_prefix  ��  ��  ��  
� m  qr����  
� R  v|��
���
�� .ascrerr ****      � ****
� m  x{
�
� �
�
� L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x��  ��  ��  
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
� 
�� .sysodlogaskr        TEXT
� m  �� � L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x  ����
�� 
disp m  ����
�� stic    ��  �  
�  l ����������  ��  ��    l ����������  ��  ��   	 l ����
��  
 / ) end of setup  //////////////////////////    � R   e n d   o f   s e t u p     / / / / / / / / / / / / / / / / / / / / / / / / / /	  l ����������  ��  ��    I �6��
�� .sysodlogaskr        TEXT l ����� b  � b  � b  � b  � b  � b  � b  �  !  m  ��"" �## ^ T h i s   i s   w h a t   w i l l   b e   u s e d : 
 o r i g i n a l   p r o j e c t : 	 	  ! o  ������  0 oldprojectname oldProjectName m   $$ �%%   
 n e w   p r o j e c t : 	 	   o  ����  0 newprojectname newProjectName m  && �'' & 
 o r i g i n a l   p r e f i x : 	 	 o  ���� 0 
old_prefix   m  (( �))  
 n e w   p r e f i x : 	 	 o  ���� 0 
new_prefix  ��  ��   ��*+
�� 
btns* J  &,, -.- m  // �00  O K. 121 m  !33 �44  R E S U B M I T2 5��5 m  !$66 �77  E X I T��  + ��89
�� 
dflt8 m  )*���� 9 ��:��
�� 
disp: m  -0��
�� stic   ��   ;<; s  7K=>= c  7>?@? l 7:A����A 1  7:��
�� 
rslt��  ��  @ m  :=��
�� 
list> J      BB C��C o      ���� 0 buttonpressed buttonPressed��  < DED l LL��������  ��  ��  E FGF Z  L�HI����H > LSJKJ o  LO���� 0 buttonpressed buttonPressedK m  ORLL �MM  E X I TI l V�NOPN Z  V�QRS��Q = V]TUT o  VY����  0 newprojectname newProjectNameU m  Y\VV �WW  R k  `uXX YZY r  `g[\[ m  `c]] �^^  R E S U B M I T\ o      ���� 0 buttonpressed buttonPressedZ _��_ I hu��`a
�� .sysodlogaskr        TEXT` m  hkbb �cc � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .a ��d��
�� 
dispd m  nq��
�� stic    ��  ��  S efe = xghg o  x{���� 0 
old_prefix  h m  {~ii �jj  f klk k  ��mm non r  ��pqp m  ��rr �ss  R E S U B M I Tq o      ���� 0 buttonpressed buttonPressedo t��t I ����uv
�� .sysodlogaskr        TEXTu m  ��ww �xx � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .v ��y��
�� 
dispy m  ����
�� stic    ��  ��  l z{z = ��|}| o  ������ 0 
new_prefix  } m  ��~~ �  { ���� k  ���� ��� r  ����� m  ���� ���  R E S U B M I T� o      ���� 0 buttonpressed buttonPressed� ���� I ������
�� .sysodlogaskr        TEXT� m  ���� ��� � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .� �����
�� 
disp� m  ����
�� stic    ��  ��  ��  ��  O ; 5 this checks to see if any answers were a null string   P ��� j   t h i s   c h e c k s   t o   s e e   i f   a n y   a n s w e r s   w e r e   a   n u l l   s t r i n g��  ��  G ���� l ����������  ��  ��  ��  	i =  ( /��� o   ( +���� 0 buttonpressed buttonPressed� m   + .�� ���  R E S U B M I T��  ��  	f ��� l     ��������  ��  ��  � ��� l �������� Z  �������� = ����� o  ���~�~ 0 buttonpressed buttonPressed� m  ���� ���  E X I T� l ������ L  ���}�}  � $  abort program by user request   � ��� <   a b o r t   p r o g r a m   b y   u s e r   r e q u e s t��  �  ��  ��  � ��� l     �|�{�z�|  �{  �z  � ��� l     �y���y  �  ////// end of User Input   � ��� 0 / / / / / /   e n d   o f   U s e r   I n p u t� ��� l     �x�w�v�x  �w  �v  � ��� l     �u�t�s�u  �t  �s  � ��� l     �r���r  � / ) Duplicate original Xcode project folder    � ��� R   D u p l i c a t e   o r i g i n a l   X c o d e   p r o j e c t   f o l d e r  � ��� l ����q�p� O  ����� r  ����� I ���o��n
�o .coreclon****      � ****� o  ���m�m 0 	thefolder 	theFolder�n  � o      �l�l 0 	newfolder 	newFolder� m  �����                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �q  �p  � ��� l     �k�j�i�k  �j  �i  � ��� l     �h���h  � = 7 set POSIX path for duplicated Folder for shell scripts   � ��� n   s e t   P O S I X   p a t h   f o r   d u p l i c a t e d   F o l d e r   f o r   s h e l l   s c r i p t s� ��� l ���g�f� r  ���� c  ����� b  ����� b  ����� o  ���e�e 0 myhome myHome� o  ���d�d  0 oldprojectname oldProjectName� m  ���� ���    c o p y /� m  ���c
�c 
TEXT� o      �b�b 0 mypath myPath�g  �f  � ��� l     �a�`�_�a  �`  �_  � ��� l     �^���^  �   create new project   � ��� &   c r e a t e   n e w   p r o j e c t� ��� l     �]���]  � ) # Launch ProgBar for the first time.   � ��� F   L a u n c h   P r o g B a r   f o r   t h e   f i r s t   t i m e .� ��� l 
��\�[� n  
��� I  
�Z�Y�X�Z 0 startprogbar startProgBar�Y  �X  �  f  �\  �[  � ��� l     �W�V�U�W  �V  �U  � ��� l Z��T�S� O  Z��� k  Y�� ��� l �R�Q�P�R  �Q  �P  � ��� l �O���O  � U O clean out duplicated project build folder before making list of project items    � ��� �   c l e a n   o u t   d u p l i c a t e d   p r o j e c t   b u i l d   f o l d e r   b e f o r e   m a k i n g   l i s t   o f   p r o j e c t   i t e m s  � ��� r  ��� c  ��� o  �N�N 0 	newfolder 	newFolder� m  �M
�M 
ctxt� o      �L�L 0 mybuildpath myBuildPath� ��K� Q  Y���J� k   P�� ��� r   /��� c   +��� b   '   o   #�I�I 0 mybuildpath myBuildPath m  #& � 
 b u i l d� m  '*�H
�H 
alis� o      �G�G 0 mybuildpath myBuildPath� �F Z  0P�E�D > 0> l 0;	�C�B	 I 0;�A

�A .earslfdrutxt  @    file
 o  03�@�@ 0 mybuildpath myBuildPath �?�>
�? 
lfiv m  67�=
�= boovfals�>  �C  �B   J  ;=�<�<   I AL�;�:
�; .coredelonull���     obj  n  AH 2 DH�9
�9 
cobj o  AD�8�8 0 mybuildpath myBuildPath�:  �E  �D  �F  � R      �7�6�5
�7 .ascrerr ****      � ****�6  �5  �J  �K  � m  �                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �T  �S  �  l [v I  [v�4�3�4 0 doonefolder doOneFolder  o  \_�2�2 0 	newfolder 	newFolder  o  _b�1�1 0 mybuildpath myBuildPath  o  be�0�0 0 
old_prefix    o  eh�/�/ 0 
new_prefix     o  hm�.�.  0 oldprojectname oldProjectName  !�-! o  mp�,�,  0 newprojectname newProjectName�-  �3   &   process all folders recursively    �"" @   p r o c e s s   a l l   f o l d e r s   r e c u r s i v e l y #$# l w�%&'% O  w�()( k  }�** +,+ l }�-./- r  }�010 o  }��+�+  0 newprojectname newProjectName1 n      232 1  ���*
�* 
pnam3 o  ���)�) 0 	newfolder 	newFolder. : 4 finally rename duplicate folder to new project name   / �44 h   f i n a l l y   r e n a m e   d u p l i c a t e   f o l d e r   t o   n e w   p r o j e c t   n a m e, 5�(5 l ��6786 n  ��9:9 I  ���'�&�%�' 0 stopprogbar stopProgBar�&  �%  :  f  ��7 I C Conclude the progress bar. This 'resets' the progress bar's state.   8 �;; �   C o n c l u d e   t h e   p r o g r e s s   b a r .   T h i s   ' r e s e t s '   t h e   p r o g r e s s   b a r ' s   s t a t e .�(  ) m  wz<<�                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  & 0 * end finder script for renaming everything   ' �== T   e n d   f i n d e r   s c r i p t   f o r   r e n a m i n g   e v e r y t h i n g$ >?> l     �$�#�"�$  �#  �"  ? @A@ l     �!BC�!  B � z Go into Project .xcodeproj package and replace all prefixes and names to fix broken links within xcode paths and targets    C �DD �   G o   i n t o   P r o j e c t   . x c o d e p r o j   p a c k a g e   a n d   r e p l a c e   a l l   p r e f i x e s   a n d   n a m e s   t o   f i x   b r o k e n   l i n k s   w i t h i n   x c o d e   p a t h s   a n d   t a r g e t s  A EFE l ��G� �G r  ��HIH c  ��JKJ b  ��LML b  ��NON b  ��PQP b  ��RSR o  ���� 0 myhome myHomeS o  ����  0 newprojectname newProjectNameQ m  ��TT �UU  /O o  ����  0 newprojectname newProjectNameM m  ��VV �WW  . x c o d e p r o jK m  ���
� 
TEXTI o      �� 0 mypath myPath�   �  F XYX l ��Z[\Z r  ��]^] m  ��__ �``  . p b x p r o j^ o      �� 0 
filesuffix 
fileSuffix[   set global variable   \ �aa (   s e t   g l o b a l   v a r i a b l eY bcb l     ����  �  �  c ded l ��f��f I  ���g�� &0 simplereplacetext simpleReplaceTextg hih m  ��jj �kk  p r o j e c t . p b x p r o ji lml o  ����  0 oldprojectname oldProjectNamem n�n o  ����  0 newprojectname newProjectName�  �  �  �  e opo l     ����  �  �  p qrq l     �st�  s _ Y --------more detailed search of project file structure to prevent incorrect replacements   t �uu �   - - - - - - - - m o r e   d e t a i l e d   s e a r c h   o f   p r o j e c t   f i l e   s t r u c t u r e   t o   p r e v e n t   i n c o r r e c t   r e p l a c e m e n t sr vwv l ��x�
�	x r  ��yzy c  ��{|{ b  ��}~} m  �� ���  p a t h   =  ~ o  ���� 0 
old_prefix  | m  ���
� 
TEXTz o      �� 0 pathoprefix  �
  �	  w ��� l ������ r  ����� c  ����� b  ����� m  ���� ���  p a t h   =  � o  ���� 0 
new_prefix  � m  ���
� 
TEXT� o      �� 0 pathnprefix  �  �  � ��� l ���� ��� I  ��������� &0 simplereplacetext simpleReplaceText� ��� m  ���� ���  p r o j e c t . p b x p r o j� ��� o  ������ 0 pathoprefix  � ���� o  ������ 0 pathnprefix  ��  ��  �   ��  � ��� l     ��������  ��  ��  � ��� l ������� r  ���� c  ���� b  ����� m  ���� ���  n a m e   =  � o  ������ 0 
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
TEXT� o      ���� 0 nibpathoprefix  ��  ��  � ��� l p������� r  p���� c  p���� b  p���� b  p}��� b  py��� m  ps�� ���  p a t h   =  � o  sx���� 0 	nibfolder 	nibFolder� m  y|�� �    \ /� o  }����� 0 
new_prefix  � m  ����
�� 
TEXT� o      ���� 0 nibpathnprefix  ��  ��  �  l ������ I  �������� &0 simplereplacetext simpleReplaceText  m  �� �  p r o j e c t . p b x p r o j 	
	 o  ������ 0 nibpathoprefix  
 �� o  ������ 0 nibpathnprefix  ��  ��  ��  ��    l     ��������  ��  ��    l ������ r  �� c  �� b  �� b  �� b  �� m  �� �  n a m e   =   o  ������ 0 	nibfolder 	nibFolder m  �� �  \ / o  ������ 0 
old_prefix   m  ����
�� 
TEXT o      ���� 0 nibpathoprefix  ��  ��     l ��!����! r  ��"#" c  ��$%$ b  ��&'& b  ��()( b  ��*+* m  ��,, �--  n a m e   =  + o  ������ 0 	nibfolder 	nibFolder) m  ��.. �//  \ /' o  ������ 0 
new_prefix  % m  ����
�� 
TEXT# o      ���� 0 nibpathnprefix  ��  ��    010 l ��2����2 I  ����3���� &0 simplereplacetext simpleReplaceText3 454 m  ��66 �77  p r o j e c t . p b x p r o j5 898 o  ������ 0 nibpathoprefix  9 :��: o  ������ 0 nibpathnprefix  ��  ��  ��  ��  1 ;<; l     ��������  ��  ��  < =>= l ��?����? r  ��@A@ c  ��BCB b  ��DED b  ��FGF b  ��HIH m  ��JJ �KK  p a t h   =  I o  ������ 0 	xibfolder 	xibFolderG m  ��LL �MM  \ /E o  ������ 0 
old_prefix  C m  ����
�� 
TEXTA o      ���� 0 xibpathoprefix  ��  ��  > NON l �P����P r  �QRQ c  �STS b  �UVU b  �WXW b  ��YZY m  ��[[ �\\  p a t h   =  Z o  ������ 0 	xibfolder 	xibFolderX m  �]] �^^  \ /V o  ���� 0 
new_prefix  T m  
��
�� 
TEXTR o      ���� 0 xibpathnprefix  ��  ��  O _`_ l a����a I  ��b���� &0 simplereplacetext simpleReplaceTextb cdc m  ee �ff  p r o j e c t . p b x p r o jd ghg o  ���� 0 xibpathoprefix  h i��i o  ���� 0 xibpathnprefix  ��  ��  ��  ��  ` jkj l     ��������  ��  ��  k lml l 8n����n r  8opo c  4qrq b  0sts b  ,uvu b  (wxw m  "yy �zz  n a m e   =  x o  "'���� 0 matlabfolder matlabFolderv m  (+{{ �||  \ /t o  ,/���� 0 
old_prefix  r m  03��
�� 
TEXTp o      ���� &0 matlabpathoprefix matlabPathoprefix��  ��  m }~} l 9R���� r  9R��� c  9N��� b  9J��� b  9F��� b  9B��� m  9<�� ���  n a m e   =  � o  <A���� 0 matlabfolder matlabFolder� m  BE�� ���  \ /� o  FI���� 0 
new_prefix  � m  JM��
�� 
TEXT� o      ���� &0 matlabpathnprefix matlabPathnprefix��  ��  ~ ��� l Sa����� I  Sa�~��}�~ &0 simplereplacetext simpleReplaceText� ��� m  TW�� ���  p r o j e c t . p b x p r o j� ��� o  WZ�|�| &0 matlabpathoprefix matlabPathoprefix� ��{� o  Z]�z�z &0 matlabpathnprefix matlabPathnprefix�{  �}  ��  �  � ��� l     �y�x�w�y  �x  �w  � ��� l     �v���v  �   clean new project   � ��� $   c l e a n   n e w   p r o j e c t� ��� l bw��u�t� r  bw��� c  bq��� b  bm��� b  bi��� o  be�s�s 0 myhome myHome� o  eh�r�r  0 newprojectname newProjectName� m  il�� ���  /� m  mp�q
�q 
TEXT� o      �p�p 0 mypath myPath�u  �t  � ��� l x����� r  x���� l x���o�n� I x��m�l��m 0 searchreplace searchReplace�l  � �k��
�k 
into� o  |��j�j 0 mypath myPath� �i��
�i 
at  � l ����h�g� m  ���� ���   �h  �g  � �f��e�f 0 replacestring replaceString� m  ���� ���  \ %�e  �o  �n  � o      �d�d 0 	shellpath 	ShellPath� H B uses global variable to overcome POSIX issue with spaces in names   � ��� �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s� ��� l ����c�b� r  ����� l ����a�`� I ���_�^��_ 0 searchreplace searchReplace�^  � �]��
�] 
into� o  ���\�\ 0 	shellpath 	ShellPath� �[��
�[ 
at  � m  ���� ���  %� �Z��Y�Z 0 replacestring replaceString� m  ���� ���   �Y  �a  �`  � o      �X�X 0 	shellpath 	ShellPath�c  �b  � ��� l     �W���W  � h bset cmd to "rm " & ShellPath & replaceScriptName -- remove sed script file from new project folder   � ��� � s e t   c m d   t o   " r m   "   &   S h e l l P a t h   &   r e p l a c e S c r i p t N a m e   - -   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e r� ��� l     �V���V  �  do shell script cmd   � ��� & d o   s h e l l   s c r i p t   c m d� ��� l ����U�T� r  ����� b  ����� b  ����� m  ���� ���  c d  � o  ���S�S 0 	shellpath 	ShellPath� m  ���� ��� < ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a n� o      �R�R 0 cmd  �U  �T  � ��� l ����Q�P� I ���O��N
�O .sysoexecTEXT���     TEXT� o  ���M�M 0 cmd  �N  �Q  �P  � ��� l     �L�K�J�L  �K  �J  � ��� l     �I���I  �   end of copyXproject   � ��� (   e n d   o f   c o p y X p r o j e c t� ��� l ����H�G� I ���F�E�D
�F .miscactvnull��� ��� null�E  �D  �H  �G  � ��� l ����C�B� I ���A��
�A .sysodlogaskr        TEXT� b  ����� o  ���@�@  0 newprojectname newProjectName� m  ���� ��� $   h a s   b e e n   c r e a t e d !� �?��>
�? 
disp� m  ���=
�= stic   �>  �C  �B  �    l     �<�;�:�<  �;  �:   �9 l     �8�7�6�8  �7  �6  �9       ^�5 > G P Y_	
�4�3�2�1 !"#$%&'()*+,-�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!� ����������������������
�	�5   \��������� ����������������������������������������������������������������������������������������������������������������������������������������������������������������������� 0 	nibfolder 	nibFolder� 0 	xibfolder 	xibFolder� 0 matlabfolder matlabFolder� &0 replacescriptname replaceScriptName�  0 oldprojectname oldProjectName� 0 mypath myPath� 0 
filesuffix 
fileSuffix� 0 doonefolder doOneFolder�  &0 replacetextinfile replaceTextInFile�� &0 simplereplacetext simpleReplaceText�� 0 searchreplace searchReplace�� 0 upcase upCase��  0 prepareprogbar prepareProgBar�� $0 incrementprogbar incrementProgBar�� 0 fadeinprogbar fadeinProgBar��  0 fadeoutprogbar fadeoutProgBar�� 0 showprogbar showProgBar�� 0 hideprogbar hideProgBar�� 0 
barberpole 
barberPole��  0 killbarberpole killBarberPole�� 0 startprogbar startProgBar�� 0 stopprogbar stopProgBar
�� .aevtoappnull  �   � ****��  0 myreservedlist myReservedList�� 0 buttonpressed buttonPressed�� 0 	thefolder 	theFolder�� 0 olddelimiter oldDelimiter�� 0 myhome myHome�� 0 totl  �� 
0 ending  �� 0 button_pressed  �� 0 text_returned  ��  0 newprojectname newProjectName�� 0 
old_prefix  �� 0 kernel_beginning  �� 0 
new_prefix  �� 0 n  �� 0 	newfolder 	newFolder�� 0 mybuildpath myBuildPath�� 0 filelist fileList�� 0 pathoprefix  �� 0 pathnprefix  �� 0 nameoprefix  �� 0 namenprefix  �� 0 nibpathoprefix  �� 0 nibpathnprefix  �� 0 xibpathoprefix  �� 0 xibpathnprefix  �� &0 matlabpathoprefix matlabPathoprefix�� &0 matlabpathnprefix matlabPathnprefix�� 0 	shellpath 	ShellPath�� 0 cmd  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��   �..  O p t i P u l s e �// X / U s e r s / m a u n s e l l / D e s k t o p / C l o n e P r o j e c t / I n c D e c / �� �����01���� 0 doonefolder doOneFolder�� ��2�� 2  �������������� 0 	thefolder 	theFolder�� 0 	buildpath 	buildPath�� 0 
old_prefix  �� 0 
new_prefix  ��  0 oldprojectname oldProjectName��  0 newprojectname newProjectName��  0 �������������������������������� 0 	thefolder 	theFolder�� 0 	buildpath 	buildPath�� 0 
old_prefix  �� 0 
new_prefix  ��  0 oldprojectname oldProjectName��  0 newprojectname newProjectName�� 0 
folderlist 
folderList�� 0 f  �� 0 numfiles numFiles�� 0 n  �� 0 currentfile currentFile�� &0 pathtocurrentfile pathToCurrentFile�� 0 filename_kernel  �� 0 testchar testChar�� 
0 locase  1 E�������������������������������������#.:\bn��������	����~�}C�|�{�z�y�x�w�v��������
",:BRn|��
�� 
cfol
�� 
pnam
�� 
leng
�� 
ctxt
�� 
cobj
�� 
alis�� �� 0 doonefolder doOneFolder
�� 
file�� 0 filelist fileList
�� 
rslt
�� .corecnte****       ****��  0 prepareprogbar prepareProgBar�� 0 fadeinprogbar fadeinProgBar�� $0 incrementprogbar incrementProgBar�� 0 kernel_beginning  �� &0 replacetextinfile replaceTextInFile
�� 
docf
�� .sysoctonshor       TEXT� A�~ Z
�} 
bool�|  
�{ .sysontocTEXT       shor�z &0 simplereplacetext simpleReplaceText
�y 
into
�x 
at  �w 0 replacestring replaceString�v 0 searchreplace searchReplace��� 
��-�,EE�UO 'k��,Ekh *��&��/%�&������+ OP[OY��O���-�,EE�O�j O�E�O)�kl+ O)kk+ O�k�kh 	)��km+ O��/EE�O��&��/%E�O��몤 Ca E�O _ �j kh 	���/%E�[OY��O)��&������+ O��%�a �/�,FY��a  �a %�a �/�,FY��a  �a %�a �/�,FYl�a  /)��&������+ O��a %  �a %�a �/�,FY hY7�a  J)��&������+ O��a %  �a %�a �/�,FY ��a %  �a %�a �/�,FY hY 窤a  %  �a !%��b   /a �/�,FY Ū�a "%  !)��&������+ O�a #%�a �/�,FY ��a $ �a %Ec  O)��&������+ O��k/j &E�O�a '	 �a (a )& 4a *E�O l�j kh 	���/%E�[OY��O�a +j ,�%E�Y hO)���m+ -O)a .�a /�a 0�� 1�a �/�,FY hOPY��a 2 �a 3%�a �/�,FY��a 4 �a 5%�a �/�,FYs�a 6 /)��&������+ O��a 7%  �a 8%�a �/�,FY hY>�a 9 J)��&������+ O��a :%  �a ;%�a �/�,FY ��a <%  �a =%�a �/�,FY hY a >%  �a ?%��b   /a �/�,FY ̪�a @%  ()��&������+ O�a A%��b  /a �/�,FY ��a B �a CEc  O)��&������+ O��k/j &E�O�a '	 �a (a )& 4a DE�O l�j kh 	���/%E�[OY��O�a +j ,�%E�Y hO)���m+ -O)a .�a /�a 0�� 1�a �/�,FY h[OY�LOPU �u �t�s34�r�u &0 replacetextinfile replaceTextInFile�t �q5�q 5  �p�o�n�m�l�k�p 0 	thefolder 	theFolder�o 0 thefile theFile�n 0 oldtext1  �m 0 newtext1  �l 0 oldtext2  �k 0 newtext2  �s  3 �j�i�h�g�f�e�d�c�b�a�`�_�j 0 	thefolder 	theFolder�i 0 thefile theFile�h 0 oldtext1  �g 0 newtext1  �f 0 oldtext2  �e 0 newtext2  �d 0 tempfile tempFile�c 0 myfolderpath myFolderPath�b 0 filename fileName�a 0 fileid fileID�` 0 	shellpath 	ShellPath�_ 0 cmd  4 4�^�]�\�[�ZSUW�Y�X[]acei�W�V�U�T�S��R��Q�P��������������O(*,.02468:O
�^ 
psxp
�] 
TEXT
�\ 
psxf
�[ 
perm
�Z .rdwropenshor       file�Y 

�X .sysontocTEXT       shor
�W 
refn
�V .rdwrwritnull���     ****
�U .rdwrclosnull���     ****
�T 
into
�S 
at  �R 0 replacestring replaceString�Q �P 0 searchreplace searchReplace
�O .sysoexecTEXT���     TEXT�rQ�E�O��,�&E�O�b  %E�O*�/�el E�O�%�%�%�%�j 
%�%�%�%�j 
%�%�%�%�%�%�j 
%a %a �l O�j O��,�&E�O*a �a a a a a  E�O*a �a a a a a  E�Oa �%�%a %�%�%a %a  %�%�%a !%a "%�%a #%�%a $%�%�%a %%�%�%a &%a '%�%�%E�O�j (Oa )�%�%a *%�%�%a +%a ,%�%�%a -%a .%�%b  %a /%�%�%a 0%�%�%a 1%a 2%�%�%E�O�j (Oa 3�%b  %E�O�j ( �N^�M�L67�K�N &0 simplereplacetext simpleReplaceText�M �J8�J 8  �I�H�G�I 0 thefile theFile�H 0 oldtext  �G 0 newtext newText�L  6 �F�E�D�C�B�A�F 0 thefile theFile�E 0 oldtext  �D 0 newtext newText�C 0 tempfile tempFile�B 0 	shellpath 	ShellPath�A 0 cmd  7 q�@�?�>��=��<�;������������:
�@ 
TEXT
�? 
into
�> 
at  �= 0 replacestring replaceString�< �; 0 searchreplace searchReplace
�: .sysoexecTEXT���     TEXT�K `�b  %�&E�O*�b  ����� E�O*������ E�O�%�%�%�%�%�%�%�%�%a %�%a %�%a %�%a %�%E�O�j 	 �9��8�79:�6�9 0 searchreplace searchReplace�8  �7 �5�4;
�5 
into�4 0 
mainstring 
mainString; �3�2<
�3 
at  �2 0 searchstring searchString< �1�0�/�1 0 replacestring replaceString�0 0 replacestring replaceString�/  9 �.�-�,�+�*�)�. 0 
mainstring 
mainString�- 0 searchstring searchString�, 0 replacestring replaceString�+ 0 foundoffset foundOffset�* 0 stringstart stringStart�) 0 	stringend 	stringEnd: �(�'�&�%�$�#
�( 
psof
�' 
psin�& 
�% .sysooffslong    ��� null
�$ 
ctxt
�# .corecnte****       ****�6 T Oh��*��� E�O�k  �E�Y �[�\[Zk\Z�k2E�O�[�\[Z��j \Zi2E�O��%�%E�[OY��O�
 �"E�!� =>��" 0 upcase upCase�! �?� ?  �� 0 astring aString�   = ����� 0 astring aString� 
0 buffer  � 0 i  � 0 testchar testChar> 	M��������
� .corecnte****       ****
� 
cobj
� .sysoctonshor       TEXT� a� z
� 
bool�  
� .sysontocTEXT       shor� Q�E�O Hk�j kh ��/j E�O��	 ���& ���j %E�OPY ��j %E�OPOP[OY��O� ����@A��  0 prepareprogbar prepareProgBar� �B� B  ��
� 0 somemaxcount someMaxCount�
 0 
windowname 
windowName�  @ �	��	 0 somemaxcount someMaxCount� 0 
windowname 
windowNameA �������� ��������������������   ��
� 
cwin
� 
bacC
� 
hasS� � � �  e����� 
�� 
cobj
�� 
levV
�� 
titl
�� 
proI
�� 
conT
�� 
minW
�� 
maxV� b� ^���mv*�/�,FOe*�/�,FOjm������v��/*�/�,FO�*�/�,FOj*�/�k/a ,FOj*�/�k/a ,FO�*�/�k/a ,FU ������CD���� $0 incrementprogbar incrementProgBar�� ��E�� E  �������� 0 
itemnumber 
itemNumber�� 0 somemaxcount someMaxCount�� 0 
windowname 
windowName��  C �������� 0 
itemnumber 
itemNumber�� 0 somemaxcount someMaxCount�� 0 
windowname 
windowNameD 
F024�������������� 0 filelist fileList
�� 
cobj
�� 
cwin
�� 
titl
�� 
proI
�� 
conT�� '� #�%�%�%�%��/%*�/�,FO�*�/�k/�,FU ��Q����FG���� 0 fadeinprogbar fadeinProgBar�� ��H�� H  ���� 0 
windowname 
windowName��  F �������� 0 
windowname 
windowName�� 0 	fadevalue 	fadeValue�� 0 i  G 
���������m��������
�� 
cwin
�� .appScentnull���    obj 
�� 
alpV
�� 
pvis�� 	
�� 
proI
�� 
usTA
�� .coVSstaAnull���    obj �� P� L*�/j Oj*�/�,FOe*�/�,FO�E�O j�kh �*�/�,FO��E�[OY��O*�/�k/�el 	U �������IJ����  0 fadeoutprogbar fadeoutProgBar�� ��K�� K  ���� 0 
windowname 
windowName��  I �������� 0 
windowname 
windowName�� 0 	fadevalue 	fadeValue�� 0 i  J 
�����������������
�� 
cwin
�� 
proI
�� 
usTA
�� .coVSstoTnull���    obj �� 	
�� 
alpV
�� 
pvis�� >� :*�/�k/�el O�E�O k�kh �*�/�,FO��E�[OY��Of*�/�,FU �������LM���� 0 showprogbar showProgBar�� ��N�� N  ���� 0 
windowname 
windowName��  L ���� 0 
windowname 
windowNameM �������������
�� 
cwin
�� .appScentnull���    obj 
�� 
pvis
�� 
proI
�� 
usTA
�� .coVSstaAnull���    obj �� %� !*�/j Oe*�/�,FO*�/�k/�el U �������OP���� 0 hideprogbar hideProgBar�� ��Q�� Q  ���� 0 
windowname 
windowName��  O ���� 0 
windowname 
windowNameP 	����������
�� 
cwin
�� 
proI
�� 
usTA
�� .coVSstoTnull���    obj 
�� 
pvis�� � *�/�k/�el Of*�/�,FU ��	����RS���� 0 
barberpole 
barberPole�� ��T�� T  ���� 0 
windowname 
windowName��  R ���� 0 
windowname 
windowNameS 	������
�� 
cwin
�� 
proI
�� 
indR�� � e*�/�k/�,FU ��	(����UV����  0 killbarberpole killBarberPole�� ��W�� W  ���� 0 
windowname 
windowName��  U ���� 0 
windowname 
windowNameV 	5������
�� 
cwin
�� 
proI
�� 
indR�� � f*�/�k/�,FU ��	@����XY���� 0 startprogbar startProgBar��  ��  X  Y 	C��
�� .ascrnoop****      � ****�� � *j U ��	N����Z[���� 0 stopprogbar stopProgBar��  ��  Z  [ 	Q��
�� .aevtquitnull��� ��� null�� � *j U ��\����]^��
�� .aevtoappnull  �   � ****\ k    �__  �`` 	[aa 	ebb �cc �dd �ee �ff �gg hh #ii Ejj Xkk dll vmm �nn �oo �pp �qq �rr �ss �tt �uu �vv �ww xx yy zz 0{{ =|| N}} _~~ l }�� ��� ��� ��� ��� ��� ��� ��� �����  ��  ��  ]  ^ � � � � � � � � � � � � � � � � � �����	b�����	y������������~�}�|�{�z	��y�x�w�v	�	��u	��t	��s	��r�q�p�o�n�m�l�k�j�i�h
�g
�f
&
(
,
2�e
S
V�d�c�b
t�a�`
�
�
�
��_�^�]�\�[�Z�Y�X�W
�
�
�
��V"$&(/36�ULV]birw~�����T�S��R�Q�P�O�N�M�L�KTV_j�J�I��H���G��F�������E���D,.6JL�C[]�Bey{�A���@�����?�����>�=�<��� ��  0 myreservedlist myReservedList�� 0 buttonpressed buttonPressed
�� 
prmp
�� .sysostflalis    ��� null
�� 
alis�� 0 	thefolder 	theFolder
�� .sysonfo4asfe        file
�� 
pnam
� 
ascr
�~ 
txdl�} 0 olddelimiter oldDelimiter
�| 
psxp
�{ 
TEXT�z 0 myhome myHome
�y 
citm
�x .corecnte****       ****�w 0 totl  �v 
0 ending  �u  
�t 
dtxt
�s 
btns
�r 
dflt�q 
�p .sysodlogaskr        TEXT
�o 
rslt
�n 
list
�m 
cobj�l 0 button_pressed  �k 0 text_returned  �j  0 newprojectname newProjectName
�i 
into
�h 
at  �g 0 replacestring replaceString�f 0 searchreplace searchReplace�e 0 
old_prefix  �d 0 upcase upCase�c 0 kernel_beginning  
�b .sysobeepnull��� ��� long
�a 
disp
�` stic    �_ 0 
new_prefix  �^ 0�] 0 n  �\ 

�[ 
psof
�Z .sysontocTEXT       shor
�Y 
psin�X 
�W .sysooffslong    ��� null�V  
�U stic   
�T .coreclon****      � ****�S 0 	newfolder 	newFolder�R 0 startprogbar startProgBar
�Q 
ctxt�P 0 mybuildpath myBuildPath
�O 
lfiv
�N .earslfdrutxt  @    file
�M .coredelonull���     obj �L 0 doonefolder doOneFolder�K 0 stopprogbar stopProgBar�J &0 simplereplacetext simpleReplaceText�I 0 pathoprefix  �H 0 pathnprefix  �G 0 nameoprefix  �F 0 namenprefix  �E 0 nibpathoprefix  �D 0 nibpathnprefix  �C 0 xibpathoprefix  �B 0 xibpathnprefix  �A &0 matlabpathoprefix matlabPathoprefix�@ &0 matlabpathnprefix matlabPathnprefix�? 0 	shellpath 	ShellPath�> 0 cmd  
�= .sysoexecTEXT���     TEXT
�< .miscactvnull��� ��� null�������������������a a vE` Oa E` O�h_ a  *a a l a &E` O_ j a ,Ec  O p_ a ,E` O_ a  ,a !&E` "Oa #_ a ,FO_ "a $-j %E` &O_ &lE` 'O_ "[a $\[Zk\Z_ '2a !&a (%E` "O_ _ a ,FW X ) *_ _ a ,FOa +a ,a -a .a /kva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` 8O*a 9_ 8a :a ;a <a =a 1 >E` 8Oa ?b  %a @%a ,a Aa .a Bkva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` CO*a 9_ Ca :a Da <a Ea 1 >E` CO*_ Ck+ FE` CO_ Cj %kE` GO_ _ C *j HOa Ia Ja Kl 2OhY hOhZa L_ 8%a M%a ,a Na .a Okva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` PO �a QE` RO =a Skh*a T_ Rj Ua V_ Pa W Xj )ja YY hO_ RkE` R[OY��O*a 9_ Pa :a Za <a [a 1 >E` PO*_ Pk+ FE` PO_ _ P *j HOa \a Ja Kl 2Y W X ] *a ^a Ja Kl 2[OY� Oa _b  %a `%_ 8%a a%_ C%a b%_ P%a .a ca da emva 0ka Ja fa 1 2O_ 3a 4&E[a 5k/EQ` ZO_ a g l_ 8a h  a iE` Oa ja Ja Kl 2Y G_ Ca k  a lE` Oa ma Ja Kl 2Y %_ Pa n  a oE` Oa pa Ja Kl 2Y hY hOP[OY�bO_ a q  hY hOa r _ j sE` tUO_ "b  %a u%a !&Ec  O)j+ vOa r J_ ta w&E` xO 5_ xa y%a &E` xO_ xa zfl {jv _ xa 5-j |Y hW X ] *hUO*_ t_ x_ C_ Pb  _ 8a 1+ }Oa r _ 8_ ta ,FO)j+ ~UO_ "_ 8%a %_ 8%a �%a !&Ec  Oa �Ec  O*a �b  _ 8m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b  %a �%_ C%a !&E` �Oa �b  %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b  %a �%_ C%a !&E` �Oa �b  %a �%_ P%a !&E` �O*a �_ �_ �m+ �O_ "_ 8%a �%a !&Ec  O*a 9b  a :a �a <a �a 1 >E` �O*a 9_ �a :a �a <a �a 1 >E` �Oa �_ �%a �%E` �O_ �j �O*j �O_ 8a �%a Ja fl 2 �;��; �   � � � � � � � � � � � � � � � � � ���  O K6alis    2  JHRM                           BD ����	OptiPulse                                                      ����            ����  J cu            0/:Users:maunsell:Desktop:CloneProject:OptiPulse/   	 O p t i P u l s e  
  J H R M  -Users/maunsell/Desktop/CloneProject/OptiPulse   /    ��   �:��: �  �� ���   ��� J / U s e r s / m a u n s e l l / D e s k t o p / C l o n e P r o j e c t /�4 �3  ���  O K ���  I D ���  I n c D e c ���  O P�2  ���  I D�1 :  �� ��9�� ��8�� ��7�� ��6�� ��5�� ��4
�4 
sdsk
�5 
cfol� ��� 
 U s e r s
�6 
cfol� ���  m a u n s e l l
�7 
cfol� ���  D e s k t o p
�8 
cfol� ���  C l o n e P r o j e c t
�9 
cfol� ���  O p t i P u l s e   c o p y! ��� p J H R M : U s e r s : m a u n s e l l : D e s k t o p : C l o n e P r o j e c t : O p t i P u l s e   c o p y :" �3��3 )� ) ������������������������������������������ ���  I n f o . p l i s t� ���  O P . h� ��� , O P B e h a v i o r C o n t r o l l e r . h� ��� , O P B e h a v i o r C o n t r o l l e r . m� ��� " O P E n d t r i a l S t a t e . h� ��� " O P E n d t r i a l S t a t e . m� ���  O P I d l e S t a t e . h� ���  O P I d l e S t a t e . m� ��� & O P I n t e r t r i a l S t a t e . h� ��� & O P I n t e r t r i a l S t a t e . m� ��� $ O P L e v e r D o w n S t a t e . h� ��� $ O P L e v e r D o w n S t a t e . m� ��� ( O P M a t l a b C o n t r o l l e r . h� ��� ( O P M a t l a b C o n t r o l l e r . m� ��� , O P S t a r t S t i m u l u s S t a t e . h� ��� , O P S t a r t S t i m u l u s S t a t e . m� ��� & O P S t a r t t r i a l S t a t e . h� ��� & O P S t a r t t r i a l S t a t e . m� ���  O P S t a t e S y s t e m . h� ���  O P S t a t e S y s t e m . m� ���  O P S t i m u l i . h� ���  O P S t i m u l i . m� ���  O P S t o p S t a t e . h� ���  O P S t o p S t a t e . m� ��� * O P S u m m a r y C o n t r o l l e r . h� ��� * O P S u m m a r y C o n t r o l l e r . m� ���  O P U t i l i t i e s . h� ���  O P U t i l i t i e s . m� ��� , O P W a i t L e v e r D o w n S t a t e . h� ��� , O P W a i t L e v e r D o w n S t a t e . m� ��� * O P W a i t R e s p o n s e S t a t e . h� ��� * O P W a i t R e s p o n s e S t a t e . m� ���   O P X T C o n t r o l l e r . h� ���   O P X T C o n t r o l l e r . m� ���  O p t i P u l s e . h� ���  O p t i P u l s e . m� ��� & O p t i P u l s e . x c o d e p r o j� ��� $ O p t i P u l s e _ P r e f i x . h� ��� " P l u g i n - I n f o . p l i s t� ��� $ U s e r D e f a u l t s . p l i s t� ���  m a i n . m# ���  p a t h   =   O P$ ���  p a t h   =   I D% ���  H E A D E R   =   O P& ���  H E A D E R   =   I D' ��� 0 n a m e   =   E n g l i s h . l p r o j \ / O P( ��� 0 n a m e   =   E n g l i s h . l p r o j \ / I D) ��� * p a t h   =   B a s e . l p r o j \ / O P* ��� * p a t h   =   B a s e . l p r o j \ / I D+ ��� " n a m e   =   M a t l a b \ / O P, �   " n a m e   =   M a t l a b \ / I D- � � c d   / U s e r s / m a u n s e l l / D e s k t o p / C l o n e P r o j e c t / I n c D e c / ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a n�0  �/  �.  �-  �,  �+  �*  �)  �(  �'  �&  �%  �$  �#  �"  �!  �   �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �
  �	  ascr  ��ޭ