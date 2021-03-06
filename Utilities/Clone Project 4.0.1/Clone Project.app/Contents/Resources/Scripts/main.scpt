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
new_prefix   �  � � � o      ����  0 oldprojectname oldProjectName �  ��� � o      ����  0 newprojectname newProjectName��  ��   � k    � � �  � � � l     �� � ���   � - ' Process subfolders first (recursively)    � � � � N   P r o c e s s   s u b f o l d e r s   f i r s t   ( r e c u r s i v e l y ) �  � � � O      � � � l    � � � � r     � � � l   
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
folderList��   HIH l  7 7��JK��  J X R Once the subfolders have been processed, process each of the files in this folder   K �LL �   O n c e   t h e   s u b f o l d e r s   h a v e   b e e n   p r o c e s s e d ,   p r o c e s s   e a c h   o f   t h e   f i l e s   i n   t h i s   f o l d e rI M��M O   7�NON k   ;�PP QRQ r   ; CSTS e   ; AUU n   ; AVWV 1   > @��
�� 
pnamW n  ; >XYX 2   < >��
�� 
fileY o   ; <���� 0 	thefolder 	theFolderT o      ���� 0 filelist fileListR Z[Z I  D I��\��
�� .corecnte****       ****\ 1   D E��
�� 
rslt��  [ ]^] r   J M_`_ 1   J K��
�� 
rslt` o      ���� 0 numfiles numFiles^ aba l  N N��cd��  c ? 9prepareProgBar(numFiles, 1) of me -- Prepare Progress Bar   d �ee r p r e p a r e P r o g B a r ( n u m F i l e s ,   1 )   o f   m e   - -   P r e p a r e   P r o g r e s s   B a rb fgf l  N N��hi��  h K EfadeinProgBar(1) of me -- Open the desired Progress Bar window style.   i �jj � f a d e i n P r o g B a r ( 1 )   o f   m e   - -   O p e n   t h e   d e s i r e d   P r o g r e s s   B a r   w i n d o w   s t y l e .g klk l  N N��mn��  m F @ rename prefixes within files  and file names of project files     n �oo �   r e n a m e   p r e f i x e s   w i t h i n   f i l e s     a n d   f i l e   n a m e s   o f   p r o j e c t   f i l e s    l pqp Y   N�r��st��r l  X�uvwu k   X�xx yzy l  X X��{|��  { J DincrementProgBar(n, numFiles, 1) of me -- Increment the progress bar   | �}} � i n c r e m e n t P r o g B a r ( n ,   n u m F i l e s ,   1 )   o f   m e   - -   I n c r e m e n t   t h e   p r o g r e s s   b a rz ~~ l  X _���� r   X _��� l  X ]������ e   X ]�� n   X ]��� 4   Y \���
�� 
cobj� o   Z [���� 0 n  � o   X Y���� 0 filelist fileList��  ��  � o      ���� 0 currentfile currentFile� #  Get the next file to process   � ��� :   G e t   t h e   n e x t   f i l e   t o   p r o c e s s ��� l  ` j���� r   ` j��� b   ` h��� l  ` c������ c   ` c��� o   ` a���� 0 	thefolder 	theFolder� m   a b��
�� 
ctxt��  ��  � l  c g������ n   c g��� 4   d g���
�� 
cobj� o   e f���� 0 n  � o   c d���� 0 filelist fileList��  ��  � o      ���� &0 pathtocurrentfile pathToCurrentFile� #  Get the next file to process   � ��� :   G e t   t h e   n e x t   f i l e   t o   p r o c e s s� ���� Z   k������� C   k n��� o   k l���� 0 currentfile currentFile� o   l m�� 0 
old_prefix  � l  qS���� k   qS�� ��� Z   qQ���~�� H   q u�� C   q t��� o   q r�}�} 0 currentfile currentFile� o   r s�|�|  0 oldprojectname oldProjectName� l  x ����� k   x ��� ��� l  x {���� r   x {��� m   x y�� ���  � o      �{�{ 0 filename_kernel  � &   extract filename without prefix   � ��� @   e x t r a c t   f i l e n a m e   w i t h o u t   p r e f i x� ��� Y   | ���z���y� r   � ���� b   � ���� o   � ��x�x 0 filename_kernel  � l  � ���w�v� n   � ���� 4   � ��u�
�u 
cobj� o   � ��t�t 0 n  � o   � ��s�s 0 currentfile currentFile�w  �v  � o      �r�r 0 filename_kernel  �z 0 n  � o    ��q�q 0 kernel_beginning  � l  � ���p�o� I  � ��n��m
�n .corecnte****       ****� o   � ��l�l 0 currentfile currentFile�m  �p  �o  �y  � ��� l  � ����� n  � ���� I   � ��k��j�k &0 replacetextinfile replaceTextInFile� ��� c   � ���� o   � ��i�i 0 	thefolder 	theFolder� m   � ��h
�h 
ctxt� ��� o   � ��g�g 0 currentfile currentFile� ��� o   � ��f�f  0 oldprojectname oldProjectName� ��� o   � ��e�e  0 newprojectname newProjectName� ��� o   � ��d�d 0 
old_prefix  � ��c� o   � ��b�b 0 
new_prefix  �c  �j  �  f   � ��   replace prefixes in file   � ��� 2   r e p l a c e   p r e f i x e s   i n   f i l e� ��a� l  � ����� r   � ���� l  � ���`�_� b   � ���� o   � ��^�^ 0 
new_prefix  � o   � ��]�] 0 filename_kernel  �`  �_  � n      ��� 1   � ��\
�\ 
pnam� n   � ���� 4   � ��[�
�[ 
docf� o   � ��Z�Z 0 currentfile currentFile� o   � ��Y�Y 0 	thefolder 	theFolder� "  change the name of the file   � ��� 8   c h a n g e   t h e   n a m e   o f   t h e   f i l e�a  � < 6 If user did not start project name with the prefix...   � ��� l   I f   u s e r   d i d   n o t   s t a r t   p r o j e c t   n a m e   w i t h   t h e   p r e f i x . . .�~  � l  �Q���� Z   �Q����X� D   � ���� o   � ��W�W 0 currentfile currentFile� m   � ��� ���  . x c o d e p r o j� l  � ����� r   � ���� b   � �   o   � ��V�V  0 newprojectname newProjectName m   � � �  . x c o d e p r o j� n       1   � ��U
�U 
pnam n   � � 4   � ��T
�T 
docf o   � ��S�S 0 currentfile currentFile o   � ��R�R 0 	thefolder 	theFolder� A ; non-special case were project name does not include prefix   � �		 v   n o n - s p e c i a l   c a s e   w e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i x� 

 D   � � o   � ��Q�Q 0 currentfile currentFile m   � � �  . p c h  l  � � r   � � b   � � o   � ��P�P  0 newprojectname newProjectName m   � � �  _ P r e f i x . p c h n       1   � ��O
�O 
pnam n   � � 4   � ��N
�N 
docf o   � ��M�M 0 currentfile currentFile o   � ��L�L 0 	thefolder 	theFolder %  precompiled header for project    �   >   p r e c o m p i l e d   h e a d e r   f o r   p r o j e c t !"! D   � �#$# o   � ��K�K 0 currentfile currentFile$ m   � �%% �&&  . m" '(' l  �)*+) k   �,, -.- n  � �/0/ I   � ��J1�I�J &0 replacetextinfile replaceTextInFile1 232 c   � �454 o   � ��H�H 0 	thefolder 	theFolder5 m   � ��G
�G 
ctxt3 676 o   � ��F�F 0 currentfile currentFile7 898 o   � ��E�E  0 oldprojectname oldProjectName9 :;: o   � ��D�D  0 newprojectname newProjectName; <=< o   � ��C�C 0 
old_prefix  = >�B> o   � ��A�A 0 
new_prefix  �B  �I  0  f   � �. ?�@? Z   �@A�?�>@ =  �BCB o   � ��=�= 0 currentfile currentFileC l  �D�<�;D b   �EFE o   � ��:�:  0 oldprojectname oldProjectNameF m   �GG �HH  . m�<  �;  A r  IJI b  KLK o  �9�9  0 newprojectname newProjectNameL m  MM �NN  . mJ n      OPO 1  �8
�8 
pnamP n  QRQ 4  �7S
�7 
docfS o  �6�6 0 currentfile currentFileR o  �5�5 0 	thefolder 	theFolder�?  �>  �@  * "  principal class for project   + �TT 8   p r i n c i p a l   c l a s s   f o r   p r o j e c t( UVU D  !WXW o  �4�4 0 currentfile currentFileX m   YY �ZZ  . hV [\[ l $i]^_] k  $i`` aba n $1cdc I  %1�3e�2�3 &0 replacetextinfile replaceTextInFilee fgf c  %(hih o  %&�1�1 0 	thefolder 	theFolderi m  &'�0
�0 
ctxtg jkj o  ()�/�/ 0 currentfile currentFilek lml o  )*�.�.  0 oldprojectname oldProjectNamem non o  *+�-�-  0 newprojectname newProjectNameo pqp o  +,�,�, 0 
old_prefix  q r�+r o  ,-�*�* 0 
new_prefix  �+  �2  d  f  $%b s�)s Z  2ituv�(t = 29wxw o  23�'�' 0 currentfile currentFilex l 38y�&�%y b  38z{z o  34�$�$  0 oldprojectname oldProjectName{ m  47|| �}}  . h�&  �%  u l <J~�~ r  <J��� b  <A��� o  <=�#�#  0 newprojectname newProjectName� m  =@�� ���  . h� n      ��� 1  GI�"
�" 
pnam� n  AG��� 4  BG�!�
�! 
docf� o  EF� �  0 currentfile currentFile� o  AB�� 0 	thefolder 	theFolder    should only happen once		   � ��� 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	v ��� = MT��� o  MN�� 0 currentfile currentFile� l NS���� b  NS��� o  NO��  0 oldprojectname oldProjectName� m  OR�� ���  _ P r e f i x . h�  �  � ��� l We���� r  We��� b  W\��� o  WX��  0 newprojectname newProjectName� m  X[�� ���  _ P r e f i x . h� n      ��� 1  bd�
� 
pnam� n  \b��� 4  ]b��
� 
docf� o  `a�� 0 currentfile currentFile� o  \]�� 0 	thefolder 	theFolder�   should only happen once	   � ��� 2   s h o u l d   o n l y   h a p p e n   o n c e 	�  �(  �)  ^ , & header of principal class for project   _ ��� L   h e a d e r   o f   p r i n c i p a l   c l a s s   f o r   p r o j e c t\ ��� =  ls��� o  lm�� 0 currentfile currentFile� b  mr��� o  mn��  0 oldprojectname oldProjectName� m  nq�� ���  . n i b� ��� l v����� r  v���� b  v{��� o  vw��  0 newprojectname newProjectName� m  wz�� ���  . n i b� n      ��� 1  ���
� 
pnam� n  {���� 4  ����
� 
docf� o  ���� 0 currentfile currentFile� n  {���� 4  |���
� 
cfol� o  }��� 0 	nibfolder 	nibFolder� o  {|�� 0 	thefolder 	theFolder�    principal nib for project   � ��� 4   p r i n c i p a l   n i b   f o r   p r o j e c t� ��� =  ����� o  ���� 0 currentfile currentFile� b  ����� o  ���
�
  0 oldprojectname oldProjectName� m  ���� ���  . x i b� ��� l ������ k  ���� ��� n ����� I  ���	���	 &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ���� 0 	thefolder 	theFolder� m  ���
� 
ctxt� ��� o  ���� 0 currentfile currentFile� ��� o  ����  0 oldprojectname oldProjectName� ��� o  ����  0 newprojectname newProjectName� ��� o  ���� 0 
old_prefix  � ��� o  ��� �  0 
new_prefix  �  �  �  f  ��� ���� r  ����� b  ����� o  ������  0 newprojectname newProjectName� m  ���� ���  . x i b� n      ��� 1  ����
�� 
pnam� n  ����� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	thefolder 	theFolder��  �    principal xib for project   � ��� 4   p r i n c i p a l   x i b   f o r   p r o j e c t� ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . p l i s t� ���� l �M���� k  �M�� ��� r  ����� m  ���� �    . p l i s t� o      ���� 0 
filesuffix 
fileSuffix�  n �� I  �������� &0 replacetextinfile replaceTextInFile  c  ��	 o  ������ 0 	thefolder 	theFolder	 m  ����
�� 
ctxt 

 o  ������ 0 currentfile currentFile  o  ������  0 oldprojectname oldProjectName  o  ������  0 newprojectname newProjectName  o  ������ 0 
old_prefix   �� o  ������ 0 
new_prefix  ��  ��    f  ��  r  �� I ������
�� .sysoctonshor       TEXT l ������ n  �� 4 ����
�� 
cobj m  ������  o  ������  0 oldprojectname oldProjectName��  ��  ��   o      ���� 0 testchar testChar  Z  �)���� F  �� !  @  ��"#" o  ������ 0 testchar testChar# m  ������ A! B  ��$%$ o  ������ 0 testchar testChar% m  ������ Z l �%&'(& k  �%)) *+* r  ��,-, m  ��.. �//  - o      ���� 
0 locase  + 010 Y  �2��34��2 r  
565 b  
787 o  
���� 
0 locase  8 l 9����9 n  :;: 4  ��<
�� 
cobj< o  ���� 0 n  ; o  ����  0 oldprojectname oldProjectName��  ��  6 o      ���� 
0 locase  �� 0 n  3 m  � ���� 4 l  =����= I  ��>��
�� .corecnte****       ****> o   ����  0 oldprojectname oldProjectName��  ��  ��  ��  1 ?��? r  %@A@ b  #BCB l !D����D I !��E��
�� .sysontocTEXT       shorE l F����F [  GHG o  ���� 0 testchar testCharH m  ����  ��  ��  ��  ��  ��  C o  !"���� 
0 locase  A o      ���� 
0 locase  ��  '   is it uppercase ?   ( �II $   i s   i t   u p p e r c a s e   ?��  ��   JKJ l *2LMNL n *2OPO I  +2��Q���� &0 simplereplacetext simpleReplaceTextQ RSR o  +,���� 0 currentfile currentFileS TUT o  ,-���� 
0 locase  U V��V o  -.����  0 newprojectname newProjectName��  ��  P  f  *+M 7 1 catch any lowercase instances of project name 		   N �WW b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 	K XYX l 33��Z[��  Z ; 5 rename only .plist files containing the projectname    [ �\\ j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  Y ]��] r  3M^_^ l 3D`����` I 3D��ab�� 0 searchreplace searchReplacea  f  34b ��cd
�� 
intoc o  78���� 0 currentfile currentFiled ��ef
�� 
at  e o  ;<����  0 oldprojectname oldProjectNamef ��g���� 0 replacestring replaceStringg o  ?@����  0 newprojectname newProjectName��  ��  ��  _ n      hih 1  JL��
�� 
pnami n  DJjkj 4  EJ��l
�� 
docfl o  HI���� 0 currentfile currentFilek o  DE���� 0 	thefolder 	theFolder��  �    property list for project   � �mm 4   p r o p e r t y   l i s t   f o r   p r o j e c t��  �X  � , & old project name includes old prefix    � �nn L   o l d   p r o j e c t   n a m e   i n c l u d e s   o l d   p r e f i x  � o��o l RR��������  ��  ��  ��  � , & If its name has got the old prefix...   � �pp L   I f   i t s   n a m e   h a s   g o t   t h e   o l d   p r e f i x . . .��  � l V�qrsq Z  V�tuv��t D  V[wxw o  VW���� 0 currentfile currentFilex m  WZyy �zz  . x c o d e p r o ju l ^l{|}{ r  ^l~~ b  ^c��� o  ^_����  0 newprojectname newProjectName� m  _b�� ���  . x c o d e p r o j n      ��� 1  ik��
�� 
pnam� n  ci��� 4  di���
�� 
docf� o  gh���� 0 currentfile currentFile� o  cd���� 0 	thefolder 	theFolder| B < non-special case where project name does not include prefix   } ��� x   n o n - s p e c i a l   c a s e   w h e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i xv ��� D  ot��� o  op���� 0 currentfile currentFile� m  ps�� ���  . p c h� ��� r  w���� b  w|��� o  wx����  0 newprojectname newProjectName� m  x{�� ���  _ P r e f i x . p c h� n      ��� 1  ����
�� 
pnam� n  |���� 4  }����
�� 
docf� o  ������ 0 currentfile currentFile� o  |}���� 0 	thefolder 	theFolder� ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . m� ��� k  ���� ��� n ����� I  ��������� &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ������ 0 	thefolder 	theFolder� m  ����
�� 
ctxt� ��� o  ������ 0 currentfile currentFile� ��� o  ������  0 oldprojectname oldProjectName� ��� o  ������  0 newprojectname newProjectName� ��� o  ������ 0 
old_prefix  � ���� o  ������ 0 
new_prefix  ��  ��  �  f  ��� ���� Z  ��������� = ����� o  ������ 0 currentfile currentFile� l �������� b  ����� o  ������  0 oldprojectname oldProjectName� m  ���� ���  . m��  ��  � l ������ r  ����� b  ����� o  ������  0 newprojectname newProjectName� m  ���� ���  . m� n      ��� 1  ����
�� 
pnam� n  ����� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	thefolder 	theFolder�   should only happen once   � ��� 0   s h o u l d   o n l y   h a p p e n   o n c e��  ��  ��  � ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . h� ��� k  �
�� ��� n ����� I  ��������� &0 replacetextinfile replaceTextInFile� ��� c  ����� o  ������ 0 	thefolder 	theFolder� m  ����
�� 
ctxt� ��� o  ������ 0 currentfile currentFile� ��� o  ����  0 oldprojectname oldProjectName� ��� o  ���~�~  0 newprojectname newProjectName� ��� o  ���}�} 0 
old_prefix  � ��|� o  ���{�{ 0 
new_prefix  �|  ��  �  f  ��� ��z� Z  �
����y� = ����� o  ���x�x 0 currentfile currentFile� l ����w�v� b  ����� o  ���u�u  0 oldprojectname oldProjectName� m  ���� ���  . h�w  �v  � l ������ r  ����� b  ����� o  ���t�t  0 newprojectname newProjectName� m  ���� ���  . h� n         1  ���s
�s 
pnam n  �� 4  ���r
�r 
docf o  ���q�q 0 currentfile currentFile o  ���p�p 0 	thefolder 	theFolder�    should only happen once		   � � 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	�  = ��	 o  ���o�o 0 currentfile currentFile	 l ��
�n�m
 b  �� o  ���l�l  0 oldprojectname oldProjectName m  �� �  _ P r e f i x . h�n  �m   �k l � r  � b  �� o  ���j�j  0 newprojectname newProjectName m  �� �  _ P r e f i x . h n       1  �i
�i 
pnam n  � 4  ��h
�h 
docf o  �g�g 0 currentfile currentFile o  ���f�f 0 	thefolder 	theFolder   should only happen once	    � 2   s h o u l d   o n l y   h a p p e n   o n c e 	�k  �y  �z  �   =  !"! o  �e�e 0 currentfile currentFile" b  #$# o  �d�d  0 oldprojectname oldProjectName$ m  %% �&&  . n i b  '(' r  %)*) b  +,+ o  �c�c  0 newprojectname newProjectName, m  -- �..  . n i b* n      /0/ 1  "$�b
�b 
pnam0 n  "121 4  "�a3
�a 
docf3 o   !�`�` 0 currentfile currentFile2 o  �_�_ 0 	thefolder 	theFolder( 454 =  (/676 o  ()�^�^ 0 currentfile currentFile7 b  ).898 o  )*�]�]  0 oldprojectname oldProjectName9 m  *-:: �;;  . x i b5 <=< k  2N>> ?@? n 2?ABA I  3?�\C�[�\ &0 replacetextinfile replaceTextInFileC DED c  36FGF o  34�Z�Z 0 	thefolder 	theFolderG m  45�Y
�Y 
ctxtE HIH o  67�X�X 0 currentfile currentFileI JKJ o  78�W�W  0 oldprojectname oldProjectNameK LML o  89�V�V  0 newprojectname newProjectNameM NON o  9:�U�U 0 
old_prefix  O P�TP o  :;�S�S 0 
new_prefix  �T  �[  B  f  23@ Q�RQ r  @NRSR b  @ETUT o  @A�Q�Q  0 newprojectname newProjectNameU m  ADVV �WW  . x i bS n      XYX 1  KM�P
�P 
pnamY n  EKZ[Z 4  FK�O\
�O 
docf\ o  IJ�N�N 0 currentfile currentFile[ o  EF�M�M 0 	thefolder 	theFolder�R  = ]^] D  QV_`_ o  QR�L�L 0 currentfile currentFile` m  RUaa �bb  . p l i s t^ c�Kc k  Y�dd efe r  Ybghg m  Y\ii �jj  . p l i s th o      �J�J 0 
filesuffix 
fileSuffixf klk n cpmnm I  dp�Io�H�I &0 replacetextinfile replaceTextInFileo pqp c  dgrsr o  de�G�G 0 	thefolder 	theFolders m  ef�F
�F 
ctxtq tut o  gh�E�E 0 currentfile currentFileu vwv o  hi�D�D  0 oldprojectname oldProjectNamew xyx o  ij�C�C  0 newprojectname newProjectNamey z{z o  jk�B�B 0 
old_prefix  { |�A| o  kl�@�@ 0 
new_prefix  �A  �H  n  f  cdl }~} r  q{� I qy�?��>
�? .sysoctonshor       TEXT� l qu��=�<� n  qu��� 4 ru�;�
�; 
cobj� m  st�:�: � o  qr�9�9  0 oldprojectname oldProjectName�=  �<  �>  � o      �8�8 0 testchar testChar~ ��� Z  |����7�6� F  |���� @  |���� o  |}�5�5 0 testchar testChar� m  }��4�4 A� B  ����� o  ���3�3 0 testchar testChar� m  ���2�2 Z� l ������ k  ���� ��� r  ����� m  ���� ���  � o      �1�1 
0 locase  � ��� Y  ����0���/� r  ����� b  ����� o  ���.�. 
0 locase  � l ����-�,� n  ����� 4  ���+�
�+ 
cobj� o  ���*�* 0 n  � o  ���)�)  0 oldprojectname oldProjectName�-  �,  � o      �(�( 
0 locase  �0 0 n  � m  ���'�' � l ����&�%� I ���$��#
�$ .corecnte****       ****� o  ���"�"  0 oldprojectname oldProjectName�#  �&  �%  �/  � ��!� r  ����� b  ����� l ���� �� I �����
� .sysontocTEXT       shor� l ������ [  ����� o  ���� 0 testchar testChar� m  ����  �  �  �  �   �  � o  ���� 
0 locase  � o      �� 
0 locase  �!  �   is it uppercase ?   � ��� $   i s   i t   u p p e r c a s e   ?�7  �6  � ��� l ������ n ����� I  ������ &0 simplereplacetext simpleReplaceText� ��� o  ���� 0 currentfile currentFile� ��� o  ���� 
0 locase  � ��� o  ����  0 newprojectname newProjectName�  �  �  f  ��� 7 1 catch any lowercase instances of project name 		   � ��� b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 	� ��� l ������  � ; 5 rename only .plist files containing the projectname    � ��� j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  � ��� r  ����� l ������ I ������ 0 searchreplace searchReplace�  f  ��� ���
� 
into� o  ���
�
 0 currentfile currentFile� �	��
�	 
at  � o  ����  0 oldprojectname oldProjectName� ���� 0 replacestring replaceString� o  ����  0 newprojectname newProjectName�  �  �  � n      ��� 1  ���
� 
pnam� n  ����� 4  ����
� 
docf� o  ���� 0 currentfile currentFile� o  ���� 0 	thefolder 	theFolder�  �K  ��  r F @ project files that don't include prefix also need to be updated   s ��� �   p r o j e c t   f i l e s   t h a t   d o n ' t   i n c l u d e   p r e f i x   a l s o   n e e d   t o   b e   u p d a t e d��  v   Do all files   w ���    D o   a l l   f i l e s�� 0 n  s m   Q R� �  t o   R S���� 0 numfiles numFiles��  q ���� l ����������  ��  ��  ��  O m   7 8���                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  ��   � ��� l     ��������  ��  ��  � ��� l     ������  � J D subroutine to replace old file names and prefixes with the new ones   � ��� �   s u b r o u t i n e   t o   r e p l a c e   o l d   f i l e   n a m e s   a n d   p r e f i x e s   w i t h   t h e   n e w   o n e s� ��� i   ��� I      ������� &0 replacetextinfile replaceTextInFile� ��� o      ���� 0 	thefolder 	theFolder� ��� o      ���� 0 thefile theFile� ��� o      ���� 0 oldtext1  � ��� o      ���� 0 newtext1  � ��� o      ���� 0 oldtext2  � ���� o      ���� 0 newtext2  ��  ��  � k    P�� ��� r     ��� m     �� ���  m y t e m p . h� o      ���� 0 tempfile tempFile� ��� r    ��� c    	��� n    � � 1    ��
�� 
psxp  o    ���� 0 	thefolder 	theFolder� m    ��
�� 
TEXT� o      ���� 0 myfolderpath myFolderPath�  l   ����     Create a script for sed    � 0   C r e a t e   a   s c r i p t   f o r   s e d  r    	 b    

 o    ���� 0 myfolderpath myFolderPath o    ���� &0 replacescriptname replaceScriptName	 o      ���� 0 filename fileName  r    " I    ��
�� .rdwropenshor       file 4    ��
�� 
psxf o    ���� 0 filename fileName ����
�� 
perm m    ��
�� boovtrue��   o      ���� 0 fileid fileID  I  # Z��
�� .rdwrwritnull���     **** b   # R b   # N b   # H b   # F b   # D !  b   # B"#" b   # @$%$ b   # >&'& b   # 8()( b   # 6*+* b   # 4,-, b   # 2./. b   # ,010 b   # *232 b   # (454 b   # &676 m   # $88 �99 $ s / \ ( [ ^ a - j l - z A - Z ] \ )7 o   $ %���� 0 oldtext2  5 m   & ':: �;;  / \ 13 o   ( )���� 0 newtext2  1 m   * +<< �==  / g/ l  , 1>����> I  , 1��?��
�� .sysontocTEXT       shor? m   , -���� 
��  ��  ��  - m   2 3@@ �AA  / ^+ o   4 5���� 0 oldtext2  ) m   6 7BB �CC  / {  ' l  8 =D����D I  8 =��E��
�� .sysontocTEXT       shorE m   8 9���� 
��  ��  ��  % m   > ?FF �GG  s /# o   @ A���� 0 oldtext2  ! m   B CHH �II  / o   D E���� 0 newtext2   m   F GJJ �KK  / 1 l  H ML����L I  H M��M��
�� .sysontocTEXT       shorM m   H I���� 
��  ��  ��   m   N QNN �OO  } ��P��
�� 
refnP o   U V���� 0 fileid fileID��   QRQ I  [ `��S��
�� .rdwrclosnull���     ****S o   [ \���� 0 fileid fileID��  R TUT l  a a��VW��  V  end if   W �XX  e n d   i fU YZY r   a h[\[ c   a f]^] n   a d_`_ 1   b d��
�� 
psxp` o   a b���� 0 	thefolder 	theFolder^ m   d e��
�� 
TEXT\ o      ���� 0 	shellpath 	ShellPathZ aba l  i �cdec r   i �fgf l  i �h����h I  i �����i�� 0 searchreplace searchReplace��  i ��jk
�� 
intoj o   m n���� 0 	shellpath 	ShellPathk ��lm
�� 
at  l l  q tn����n m   q too �pp   ��  ��  m ��q���� 0 replacestring replaceStringq m   w zrr �ss  \ %��  ��  ��  g o      ���� 0 	shellpath 	ShellPathd H B uses global variable to overcome POSIX issue with spaces in names   e �tt �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e sb uvu r   � �wxw l  � �y����y I  � �����z�� 0 searchreplace searchReplace��  z ��{|
�� 
into{ o   � ����� 0 	shellpath 	ShellPath| ��}~
�� 
at  } m   � � ���  %~ ������� 0 replacestring replaceString� m   � ��� ���   ��  ��  ��  x o      ���� 0 	shellpath 	ShellPathv ��� l  � �������  � 7 1 replace occurences of oldProject with newProject   � ��� b   r e p l a c e   o c c u r e n c e s   o f   o l d P r o j e c t   w i t h   n e w P r o j e c t� ��� r   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� m   � ��� ��� 
 c a t    � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� m   � ��� ���    ;  � m   � ��� ���      >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    ;  � m   � ��� ���    s e d   - e   ' s /� o   � ����� 0 oldtext1  � m   � ��� ���  /� o   � ����� 0 newtext1  � m   � ��� ���  / g '  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� m   � ��� ���    >  � o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 thefile theFile� m   � ��� ���    ;  � m   � ��� ���    >� o   � ����� 0 	shellpath 	ShellPath� o   � ����� 0 tempfile tempFile� o      ���� 0 cmd  � ��� I  � ������
�� .sysoexecTEXT���     TEXT� o   � ����� 0 cmd  ��  � ��� l  � �������  � 5 / replace occurences of oldPrefix with newPrefix   � ��� ^   r e p l a c e   o c c u r e n c e s   o f   o l d P r e f i x   w i t h   n e w P r e f i x� ��� r   �6��� b   �4��� b   �2��� b   �0��� b   �,��� b   �(��� b   �&��� b   �$��� b   � ��� b   ���� b   ���� b   ���� b   ���� b   ���� b   ���� b   ���� b   ���� b   �� � b   �  b   � � b   � � b   � � b   � �	
	 b   � � m   � � �  c a t   o   � ����� 0 	shellpath 	ShellPath
 o   � ����� 0 thefile theFile m   � � �    >   o   � ����� 0 	shellpath 	ShellPath o   � ����� 0 tempfile tempFile m   � � �    ;    m    �    >  � o  ���� 0 	shellpath 	ShellPath� o  ���� 0 thefile theFile� m   �    ;  � m   �    s e d   - f  � o  ���� 0 	shellpath 	ShellPath� o  ���� &0 replacescriptname replaceScriptName� m   �   � o  ���� 0 	shellpath 	ShellPath� o  ���� 0 tempfile tempFile� m   # �    >  � o  $%���� 0 	shellpath 	ShellPath� o  &'���� 0 thefile theFile� m  (+ �    ;  � m  ,/ �      r m   - f  � o  01���� 0 	shellpath 	ShellPath� o  23���� 0 tempfile tempFile� o      ���� 0 cmd  � !"! I 7<��#��
�� .sysoexecTEXT���     TEXT# o  78���� 0 cmd  ��  " $%$ l ==��&'��  &   delete the temp file   ' �(( *   d e l e t e   t h e   t e m p   f i l e% )*) l =J+,-+ r  =J./. b  =H010 b  =B232 m  =@44 �55  r m  3 o  @A���� 0 	shellpath 	ShellPath1 o  BG�� &0 replacescriptname replaceScriptName/ o      �~�~ 0 cmd  , 5 / remove sed script file from new project folder   - �66 ^   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e r* 7�}7 I KP�|8�{
�| .sysoexecTEXT���     TEXT8 o  KL�z�z 0 cmd  �{  �}  � 9:9 l     �y�x�w�y  �x  �w  : ;<; l     �v=>�v  = U O simple form of replaceTextinFile subroutine to handle plist and project files    > �?? �   s i m p l e   f o r m   o f   r e p l a c e T e x t i n F i l e   s u b r o u t i n e   t o   h a n d l e   p l i s t   a n d   p r o j e c t   f i l e s  < @A@ i    BCB I      �uD�t�u &0 simplereplacetext simpleReplaceTextD EFE o      �s�s 0 thefile theFileF GHG o      �r�r 0 oldtext  H I�qI o      �p�p 0 newtext newText�q  �t  C k     _JJ KLK l    MNOM r     PQP c     	RSR b     TUT m     VV �WW  t e m pU o    �o�o 0 
filesuffix 
fileSuffixS m    �n
�n 
TEXTQ o      �m�m 0 tempfile tempFileN %  use global variable fileSuffix   O �XX >   u s e   g l o b a l   v a r i a b l e   f i l e S u f f i xL YZY l   [\][ r    ^_^ l   `�l�k` I   �j�ia�j 0 searchreplace searchReplace�i  a �hbc
�h 
intob o    �g�g 0 mypath myPathc �fde
�f 
at  d l   f�e�df m    gg �hh   �e  �d  e �ci�b�c 0 replacestring replaceStringi m    jj �kk  \ %�b  �l  �k  _ o      �a�a 0 	shellpath 	ShellPath\ H B uses global variable to overcome POSIX issue with spaces in names   ] �ll �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e sZ mnm r    +opo l   )q�`�_q I   )�^�]r�^ 0 searchreplace searchReplace�]  r �\st
�\ 
intos o     !�[�[ 0 	shellpath 	ShellPatht �Zuv
�Z 
at  u m   " #ww �xx  %v �Yy�X�Y 0 replacestring replaceStringy m   $ %zz �{{   �X  �`  �_  p o      �W�W 0 	shellpath 	ShellPathn |}| l  , Y~�~ r   , Y��� b   , W��� b   , U��� b   , Q��� b   , O��� b   , K��� b   , I��� b   , E��� b   , C��� b   , ?��� b   , =��� b   , ;��� b   , 9��� b   , 7��� b   , 5��� b   , 3��� b   , 1��� b   , /��� m   , -�� ���  b a s h ;   c d  � o   - .�V�V 0 	shellpath 	ShellPath� m   / 0�� ���  ;   c a t  � o   1 2�U�U 0 thefile theFile� m   3 4�� ���    >  � o   5 6�T�T 0 tempfile tempFile� m   7 8�� ���  ;   >� o   9 :�S�S 0 thefile theFile� m   ; <�� ���  ;   s e d   - e   ' s /� o   = >�R�R 0 oldtext  � m   ? B�� ���  /� o   C D�Q�Q 0 newtext newText� m   E H�� ���  / g '  � o   I J�P�P 0 tempfile tempFile� m   K N�� ���    >  � o   O P�O�O 0 thefile theFile� m   Q T�� ���  ;   r m   - f  � o   U V�N�N 0 tempfile tempFile� o      �M�M 0 cmd     and clean up!   � ���    a n d   c l e a n   u p !} ��L� I  Z _�K��J
�K .sysoexecTEXT���     TEXT� o   Z [�I�I 0 cmd  �J  �L  A ��� l     �H�G�F�H  �G  �F  � ��� l     �E���E  � j d universal search and replace subroutine -- operates strictly in AppleScript on a string or document   � ��� �   u n i v e r s a l   s e a r c h   a n d   r e p l a c e   s u b r o u t i n e   - -   o p e r a t e s   s t r i c t l y   i n   A p p l e S c r i p t   o n   a   s t r i n g   o r   d o c u m e n t� ��� i   ! $��� I      �D�C��D 0 searchreplace searchReplace�C  � �B��
�B 
into� o      �A�A 0 
mainstring 
mainString� �@��
�@ 
at  � o      �?�? 0 searchstring searchString� �>��=�> 0 replacestring replaceString� o      �<�< 0 replacestring replaceString�=  � k     S�� ��� V     P��� l   K���� k    K�� ��� l   �;���;  � v p we use offset command here to derive the position within the document where the search string first appears       � ��� �   w e   u s e   o f f s e t   c o m m a n d   h e r e   t o   d e r i v e   t h e   p o s i t i o n   w i t h i n   t h e   d o c u m e n t   w h e r e   t h e   s e a r c h   s t r i n g   f i r s t   a p p e a r s        � ��� r    ��� I   �:�9�
�: .sysooffslong    ��� null�9  � �8��
�8 
psof� o   
 �7�7 0 searchstring searchString� �6��5
�6 
psin� o    �4�4 0 
mainstring 
mainString�5  � o      �3�3 0 foundoffset foundOffset� ��� l   �2���2  � � � begin assembling remade string by getting all text up to the search location, minus the first character of the search string      � ���    b e g i n   a s s e m b l i n g   r e m a d e   s t r i n g   b y   g e t t i n g   a l l   t e x t   u p   t o   t h e   s e a r c h   l o c a t i o n ,   m i n u s   t h e   f i r s t   c h a r a c t e r   o f   t h e   s e a r c h   s t r i n g      � ��� Z    /���1�� =   ��� o    �0�0 0 foundoffset foundOffset� m    �/�/ � l   ���� r    ��� m    �� ���  � o      �.�. 0 stringstart stringStart� \ V search string starts at beginning, most likely to occur when searching a small string   � ��� �   s e a r c h   s t r i n g   s t a r t s   a t   b e g i n n i n g ,   m o s t   l i k e l y   t o   o c c u r   w h e n   s e a r c h i n g   a   s m a l l   s t r i n g�1  � r     /��� n     -��� 7  ! -�-��
�- 
ctxt� m   % '�,�, � l  ( ,��+�*� \   ( ,��� o   ) *�)�) 0 foundoffset foundOffset� m   * +�(�( �+  �*  � o     !�'�' 0 
mainstring 
mainString� o      �&�& 0 stringstart stringStart� ��� l  0 0�% �%    / ) get the end part of the remade string       � R   g e t   t h e   e n d   p a r t   o f   t h e   r e m a d e   s t r i n g      �  r   0 C n   0 A 7  1 A�$	

�$ 
ctxt	 l  5 =�#�" [   5 = o   6 7�!�! 0 foundoffset foundOffset l  7 <� � I  7 <��
� .corecnte****       **** o   7 8�� 0 searchstring searchString�  �   �  �#  �"  
 m   > @���� o   0 1�� 0 
mainstring 
mainString o      �� 0 	stringend 	stringEnd  l  D D��   C = remake mainString to start, replace string and end string       � z   r e m a k e   m a i n S t r i n g   t o   s t a r t ,   r e p l a c e   s t r i n g   a n d   e n d   s t r i n g       � r   D K b   D I b   D G o   D E�� 0 stringstart stringStart o   E F�� 0 replacestring replaceString o   G H�� 0 	stringend 	stringEnd o      �� 0 
mainstring 
mainString�  � 6 0 will not do anything if search string not found   � � `   w i l l   n o t   d o   a n y t h i n g   i f   s e a r c h   s t r i n g   n o t   f o u n d� E     o    �� 0 
mainstring 
mainString o    �� 0 searchstring searchString� � l  Q S !"  L   Q S## o   Q R�� 0 
mainstring 
mainString! "  ship it back to the caller    " �$$ 8   s h i p   i t   b a c k   t o   t h e   c a l l e r  �  � %&% l     ����  �  �  & '(' i  % ()*) I      �+�
� 0 upcase upCase+ ,�	, o      �� 0 astring aString�	  �
  * k     P-- ./. r     010 m     22 �33  1 o      �� 
0 buffer  / 454 Y    M6�78�6 k    H99 :;: r    <=< l   >��> I   �?�
� .sysoctonshor       TEXT? n    @A@ 4    � B
�  
cobjB o    ���� 0 i  A o    ���� 0 astring aString�  �  �  = o      ���� 0 testchar testChar; CDC l   ��������  ��  ��  D EFE Z    FGH��IG F    (JKJ @     LML o    ���� 0 testchar testCharM m    ���� aK B   # &NON o   # $���� 0 testchar testCharO m   $ %���� zH k   + 8PP QRQ l  + +��ST��  S D > if lowercase ascii character then change to uppercase version   T �UU |   i f   l o w e r c a s e   a s c i i   c h a r a c t e r   t h e n   c h a n g e   t o   u p p e r c a s e   v e r s i o nR VWV r   + 6XYX b   + 4Z[Z o   + ,���� 
0 buffer  [ l  , 3\����\ I  , 3��]��
�� .sysontocTEXT       shor] l  , /^����^ \   , /_`_ o   , -���� 0 testchar testChar` m   - .����  ��  ��  ��  ��  ��  Y o      ���� 
0 buffer  W a��a l  7 7��������  ��  ��  ��  ��  I k   ; Fbb cdc l  ; ;��ef��  e   do not chage character   f �gg .   d o   n o t   c h a g e   c h a r a c t e rd hih r   ; Djkj b   ; Blml o   ; <���� 
0 buffer  m l  < An����n I  < A��o��
�� .sysontocTEXT       shoro l  < =p����p o   < =���� 0 testchar testChar��  ��  ��  ��  ��  k o      ���� 
0 buffer  i q��q l  E E��������  ��  ��  ��  F r��r l  G G��������  ��  ��  ��  � 0 i  7 m    ���� 8 I   ��s��
�� .corecnte****       ****s o    	���� 0 astring aString��  �  5 tut l  N N��������  ��  ��  u v��v L   N Pww o   N O���� 
0 buffer  ��  ( xyx l     ��������  ��  ��  y z{z l     ��|}��  |   T.J. Mahaffey | 9.9.2004   } �~~ 2   T . J .   M a h a f f e y   |   9 . 9 . 2 0 0 4{ � l     ������  �   1951FDG | 8.4.2011   � ��� &   1 9 5 1 F D G   |   8 . 4 . 2 0 1 1� ��� l     ������  � � � The code contained herein is free. Re-use at will, but please include a web bookmark or weblocation file to my website if you do.   � ���   T h e   c o d e   c o n t a i n e d   h e r e i n   i s   f r e e .   R e - u s e   a t   w i l l ,   b u t   p l e a s e   i n c l u d e   a   w e b   b o o k m a r k   o r   w e b l o c a t i o n   f i l e   t o   m y   w e b s i t e   i f   y o u   d o .� ��� l     ������  � ; 5 Or simply some kind of acknowledgement in your code.   � ��� j   O r   s i m p l y   s o m e   k i n d   o f   a c k n o w l e d g e m e n t   i n   y o u r   c o d e .� ��� l     ��������  ��  ��  � ��� l     ������  � ' ! Prepare progress bar subroutine.   � ��� B   P r e p a r e   p r o g r e s s   b a r   s u b r o u t i n e .� ��� i   ) ,��� I      �������  0 prepareprogbar prepareProgBar� ��� o      ���� 0 somemaxcount someMaxCount� ���� o      ���� 0 
windowname 
windowName��  ��  � O     a��� k    `�� ��� r    ��� J    	�� ��� m    ����   ��� ��� m    ����   ��� ���� m    ����   ����  � n      ��� m    ��
�� 
bacC� 4   	 ���
�� 
cwin� o    ���� 0 
windowname 
windowName� ��� r    ��� m    ��
�� boovtrue� n      ��� m    ��
�� 
hasS� 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName� ��� r    -��� n    &��� 4   # &���
�� 
cobj� m   $ %���� � J    #�� ��� m    ����  � ��� m    ���� � ��� m    ���� � ��� m    ���� � ��� m    ���� � ��� m     ���� e� ���� m     !�������  � n      ��� m   * ,��
�� 
levV� 4   & *���
�� 
cwin� o   ( )���� 0 
windowname 
windowName� ��� r   . 6��� m   . /�� ���  � n      ��� m   3 5��
�� 
titl� 4   / 3���
�� 
cwin� o   1 2���� 0 
windowname 
windowName� ��� r   7 D��� m   7 8����  � n      ��� m   ? C��
�� 
conT� n   8 ?��� 4   < ?���
�� 
proI� m   = >���� � 4   8 <���
�� 
cwin� o   : ;���� 0 
windowname 
windowName� ��� r   E R��� m   E F����  � n      ��� m   M Q��
�� 
minW� n   F M��� 4   J M���
�� 
proI� m   K L���� � 4   F J���
�� 
cwin� o   H I���� 0 
windowname 
windowName� ���� r   S `��� o   S T���� 0 somemaxcount someMaxCount� n      ��� m   [ _��
�� 
maxV� n   T [��� 4   X [���
�� 
proI� m   Y Z���� � 4   T X���
�� 
cwin� o   V W���� 0 
windowname 
windowName��  � m     ���                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  � ��� l     ��������  ��  ��  � ��� l     ������  � ) # Increment progress bar subroutine.   � ��� F   I n c r e m e n t   p r o g r e s s   b a r   s u b r o u t i n e .� ��� i   - 0��� I      ������� $0 incrementprogbar incrementProgBar� � � o      ���� 0 
itemnumber 
itemNumber   o      ���� 0 somemaxcount someMaxCount �� o      ���� 0 
windowname 
windowName��  ��  � O     & k    %  r    	
	 b     b     b     b    	 b     m     �  P r o c e s s i n g   o    ���� 0 
itemnumber 
itemNumber m     �    o f   o   	 
���� 0 somemaxcount someMaxCount m     �    -   l   ��� n     4    �~
�~ 
cobj o    �}�} 0 
itemnumber 
itemNumber o    �|�| 0 filelist fileList��  �  
 n        m    �{
�{ 
titl  4    �z!
�z 
cwin! o    �y�y 0 
windowname 
windowName "�x" r    %#$# o    �w�w 0 
itemnumber 
itemNumber$ n      %&% m   " $�v
�v 
conT& n    "'(' 4    "�u)
�u 
proI) m     !�t�t ( 4    �s*
�s 
cwin* o    �r�r 0 
windowname 
windowName�x   m     ++�                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  � ,-, l     �q�p�o�q  �p  �o  - ./. l     �n01�n  0 %  Fade in a progress bar window.   1 �22 >   F a d e   i n   a   p r o g r e s s   b a r   w i n d o w ./ 343 i   1 4565 I      �m7�l�m 0 fadeinprogbar fadeinProgBar7 8�k8 o      �j�j 0 
windowname 
windowName�k  �l  6 O     O9:9 k    N;; <=< I   �i>�h
�i .appScent****      � ****> 4    �g?
�g 
cwin? o    �f�f 0 
windowname 
windowName�h  = @A@ r    BCB m    �e�e  C n      DED m    �d
�d 
alpVE 4    �cF
�c 
cwinF o    �b�b 0 
windowname 
windowNameA GHG r    IJI m    �a
�a boovtrueJ n      KLK 1    �`
�` 
pvisL 4    �_M
�_ 
cwinM o    �^�^ 0 
windowname 
windowNameH NON r    "PQP m     RR ?�������Q o      �]�] 0 	fadevalue 	fadeValueO STS Y   # @U�\VW�[U k   - ;XX YZY r   - 5[\[ o   - .�Z�Z 0 	fadevalue 	fadeValue\ n      ]^] m   2 4�Y
�Y 
alpV^ 4   . 2�X_
�X 
cwin_ o   0 1�W�W 0 
windowname 
windowNameZ `�V` r   6 ;aba [   6 9cdc o   6 7�U�U 0 	fadevalue 	fadeValued m   7 8ee ?�������b o      �T�T 0 	fadevalue 	fadeValue�V  �\ 0 i  V m   & '�S�S  W m   ' (�R�R 	�[  T f�Qf I  A N�Pgh
�P .coVSstaA****      � ****g n   A Hiji 4   E H�Ok
�O 
proIk m   F G�N�N j 4   A E�Ml
�M 
cwinl o   C D�L�L 0 
windowname 
windowNameh �Km�J
�K 
usTAm m   I J�I
�I boovtrue�J  �Q  : m     nn�                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  4 opo l     �H�G�F�H  �G  �F  p qrq l     �Est�E  s &   Fade out a progress bar window.   t �uu @   F a d e   o u t   a   p r o g r e s s   b a r   w i n d o w .r vwv i   5 8xyx I      �Dz�C�D  0 fadeoutprogbar fadeoutProgBarz {�B{ o      �A�A 0 
windowname 
windowName�B  �C  y O     =|}| k    <~~ � I   �@��
�@ .coVSstoT****      � ****� n    ��� 4    �?�
�? 
proI� m   	 
�>�> � 4    �=�
�= 
cwin� o    �<�< 0 
windowname 
windowName� �;��:
�; 
usTA� m    �9
�9 boovtrue�:  � ��� r    ��� m    �� ?�������� o      �8�8 0 	fadevalue 	fadeValue� ��� Y    3��7���6� k     .�� ��� r     (��� o     !�5�5 0 	fadevalue 	fadeValue� n      ��� m   % '�4
�4 
alpV� 4   ! %�3�
�3 
cwin� o   # $�2�2 0 
windowname 
windowName� ��1� r   ) .��� \   ) ,��� o   ) *�0�0 0 	fadevalue 	fadeValue� m   * +�� ?�������� o      �/�/ 0 	fadevalue 	fadeValue�1  �7 0 i  � m    �.�. � m    �-�- 	�6  � ��,� r   4 <��� m   4 5�+
�+ boovfals� n      ��� 1   9 ;�*
�* 
pvis� 4   5 9�)�
�) 
cwin� o   7 8�(�( 0 
windowname 
windowName�,  } m     ���                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  w ��� l     �'�&�%�'  �&  �%  � ��� l     �$���$  �    Show progress bar window.   � ��� 4   S h o w   p r o g r e s s   b a r   w i n d o w .� ��� i   9 <��� I      �#��"�# 0 showprogbar showProgBar� ��!� o      � �  0 
windowname 
windowName�!  �"  � O     $��� k    #�� ��� I   ���
� .appScent****      � ****� 4    ��
� 
cwin� o    �� 0 
windowname 
windowName�  � ��� r    ��� m    �
� boovtrue� n      ��� 1    �
� 
pvis� 4    ��
� 
cwin� o    �� 0 
windowname 
windowName� ��� I   #���
� .coVSstaA****      � ****� n    ��� 4    ��
� 
proI� m    �� � 4    ��
� 
cwin� o    �� 0 
windowname 
windowName� ���
� 
usTA� m    �
� boovtrue�  �  � m     ���                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  � ��� l     ����  �  �  � ��� l     ����  �    Hide progress bar window.   � ��� 4   H i d e   p r o g r e s s   b a r   w i n d o w .� ��� i   = @��� I      �
��	�
 0 hideprogbar hideProgBar� ��� o      �� 0 
windowname 
windowName�  �	  � O     ��� k    �� ��� I   ���
� .coVSstoT****      � ****� n    ��� 4    ��
� 
proI� m   	 
�� � 4    ��
� 
cwin� o    �� 0 
windowname 
windowName� ��� 
� 
usTA� m    ��
�� boovtrue�   � ���� r    ��� m    ��
�� boovfals� n      ��� 1    ��
�� 
pvis� 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName��  � m     ���                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  � ��� l     ��������  ��  ��  � ��� l     ������  � 7 1 Enable 'barber pole' behavior of a progress bar.   � ��� b   E n a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .� ��� i   A D��� I      ������� 0 
barberpole 
barberPole� ���� o      ���� 0 
windowname 
windowName��  ��  � O     ��� r    ��� m    ��
�� boovtrue� n      ��� m    ��
�� 
indR� n    ��� 4   	 ��	 
�� 
proI	  m   
 ���� � 4    	��	
�� 
cwin	 o    ���� 0 
windowname 
windowName� m     		�                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  � 			 l     ��������  ��  ��  	 			 l     ��		��  	 8 2 Disable 'barber pole' behavior of a progress bar.   	 �				 d   D i s a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .	 	
		
 i   E H			 I      ��	����  0 killbarberpole killBarberPole	 	��	 o      ���� 0 
windowname 
windowName��  ��  	 O     			 r    			 m    ��
�� boovfals	 n      			 m    ��
�� 
indR	 n    			 4   	 ��	
�� 
proI	 m   
 ���� 	 4    	��	
�� 
cwin	 o    ���� 0 
windowname 
windowName	 m     		�                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  	 			 l     ��������  ��  ��  	 			 l     ��		 ��  	   Launch ProgBar.   	  �	!	!     L a u n c h   P r o g B a r .	 	"	#	" i   I L	$	%	$ I      �������� 0 startprogbar startProgBar��  ��  	% O     
	&	'	& I   	������
�� .ascrnoop****      � ****��  ��  	' m     	(	(�                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  	# 	)	*	) l     ��������  ��  ��  	* 	+	,	+ l     ��	-	.��  	-   Quit ProgBar.   	. �	/	/    Q u i t   P r o g B a r .	, 	0	1	0 i   M P	2	3	2 I      �������� 0 stopprogbar stopProgBar��  ��  	3 O     
	4	5	4 I   	������
�� .aevtquitnull��� ��� null��  ��  	5 m     	6	6�                                                                                      @ alis    �  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 4.0.1   L/:Users:Shared:Lablib:Lablib-Core:Utilities:Clone Project 4.0.1:ProgBar.app/    P r o g B a r . a p p  
  J H R M  IUsers/Shared/Lablib/Lablib-Core/Utilities/Clone Project 4.0.1/ProgBar.app   / ��  	1 	7	8	7 l     ��������  ��  ��  	8 	9	:	9 l     ��	;	<��  	;  ////////////  User input   	< �	=	= 0 / / / / / / / / / / / /     U s e r   i n p u t	: 	>	?	> l     ��������  ��  ��  	? 	@	A	@ l   #	B	C	D	B r    #	E	F	E m    	G	G �	H	H  R E S U B M I T	F o      ���� 0 buttonpressed buttonPressed	C   at least try one time   	D �	I	I ,   a t   l e a s t   t r y   o n e   t i m e	A 	J	K	J l  $�	L����	L V   $�	M	N	M k   0�	O	O 	P	Q	P l  0 0��	R	S��  	R + %  User chooses project folder to copy   	S �	T	T J     U s e r   c h o o s e s   p r o j e c t   f o l d e r   t o   c o p y	Q 	U	V	U r   0 C	W	X	W c   0 ?	Y	Z	Y l  0 ;	[����	[ I  0 ;����	\
�� .sysostflalis    ��� null��  	\ ��	]��
�� 
prmp	] m   4 7	^	^ �	_	_ h T o   d u p l i c a t e :   c h o o s e   P l u g i n   p r o j e c t   t o   u s e   a s   s o u r c e��  ��  ��  	Z m   ; >��
�� 
alis	X o      ���� 0 	thefolder 	theFolder	V 	`	a	` r   D U	b	c	b n   D O	d	e	d 1   K O��
�� 
pnam	e l  D K	f����	f I  D K��	g��
�� .sysonfo4asfe        file	g o   D G���� 0 	thefolder 	theFolder��  ��  ��  	c o      ����  0 oldprojectname oldProjectName	a 	h	i	h l  V V��������  ��  ��  	i 	j	k	j l  V V��	l	m��  	l s m this extracts the path to folder in which the duplicated project folder resides and gives it the name myHome   	m �	n	n �   t h i s   e x t r a c t s   t h e   p a t h   t o   f o l d e r   i n   w h i c h   t h e   d u p l i c a t e d   p r o j e c t   f o l d e r   r e s i d e s   a n d   g i v e s   i t   t h e   n a m e   m y H o m e	k 	o	p	o l  V V��	q	r��  	q 1 + POSIX format because used by shell scripts   	r �	s	s V   P O S I X   f o r m a t   b e c a u s e   u s e d   b y   s h e l l   s c r i p t s	p 	t	u	t Q   V �	v	w	x	v k   Y �	y	y 	z	{	z r   Y d	|	}	| n  Y `	~		~ 1   \ `��
�� 
txdl	 1   Y \��
�� 
ascr	} o      ���� 0 olddelimiter oldDelimiter	{ 	�	�	� r   e t	�	�	� c   e p	�	�	� n   e l	�	�	� 1   h l��
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
ascr��  	w R      ��	���
�� .ascrerr ****      � ****	� m      	�	� �	�	� ~ e r r o r   o c c u r r e d   a t t e m p t i n g   t o   e x t r a c t   p a t h   t o   n e w   p r o j e c t   f o l d e r��  	x r   � �	�	�	� o   � ����� 0 olddelimiter oldDelimiter	� n     	�	�	� 1   � ���
�� 
txdl	� 1   � ���
�� 
ascr	u 	�	�	� l  � ���������  ��  ��  	� 	�	�	� l  � ���	�	���  	� ? 9 User chooses the name they wish to give the project copy   	� �	�	� r   U s e r   c h o o s e s   t h e   n a m e   t h e y   w i s h   t o   g i v e   t h e   p r o j e c t   c o p y	� 	�	�	� I  � ���	�	�
�� .sysodlogaskr        TEXT	� m   � �	�	� �	�	� & N a m e   o f   n e w   p l u g i n ?	� ��	�	�
�� 
dtxt	� m   � �	�	� �	�	�  n e w P l u g i n	� ��	�	�
�� 
btns	� J   � �	�	� 	��	� m   � �	�	� �	�	�    O K�  	� �~	��}
�~ 
dflt	� m   � ��|�| �}  	� 	�	�	� s   �	�	�	� c   � �	�	�	� l  � �	��{�z	� 1   � ��y
�y 
rslt�{  �z  	� m   � ��x
�x 
list	� J      	�	� 	�	�	� o      �w�w 0 button_pressed  	� 	��v	� o      �u�u 0 text_returned  �v  	� 	�	�	� r   	�	�	� c  	�	�	� o  �t�t 0 text_returned  	� m  �s
�s 
TEXT	� o      �r�r  0 newprojectname newProjectName	� 	�	�	� l !>	�	�	�	� r  !>	�	�	� l !:	��q�p	� I !:�o�n	��o 0 searchreplace searchReplace�n  	� �m	�	�
�m 
into	� o  %(�l�l  0 newprojectname newProjectName	� �k	�	�
�k 
at  	� m  +.	�	� �	�	�   	� �j	��i�j 0 replacestring replaceString	� m  14	�	� �	�	�  �i  �q  �p  	� o      �h�h  0 newprojectname newProjectName	�   remove all spaces   	� �	�	� $   r e m o v e   a l l   s p a c e s	� 	�	�	� l ??�g�f�e�g  �f  �e  	� 	�	�	� l ??�d�c�b�d  �c  �b  	� 	�	�	� l ??�a	�
 �a  	� ? 9 User provides the current prefix of the original project   
  �

 r   U s e r   p r o v i d e s   t h e   c u r r e n t   p r e f i x   o f   t h e   o r i g i n a l   p r o j e c t	� 


 I ?d�`


�` .sysodlogaskr        TEXT
 l ?L
�_�^
 b  ?L


 b  ?H
	


	 m  ?B

 �

 > W h a t   i s   t h e   c u r r e n t   p r e f i x   f o r  

 o  BG�]�]  0 oldprojectname oldProjectName
 m  HK

 �

    ?�_  �^  
 �\


�\ 
dtxt
 m  OR

 �

  F T
 �[


�[ 
btns
 J  UZ

 
�Z
 m  UX

 �

  O K�Z  
 �Y
�X
�Y 
dflt
 m  ]^�W�W �X  
 


 s  e�


 c  el


 l eh
 �V�U
  1  eh�T
�T 
rslt�V  �U  
 m  hk�S
�S 
list
 J      
!
! 
"
#
" o      �R�R 0 button_pressed  
# 
$�Q
$ o      �P�P 0 text_returned  �Q  
 
%
&
% r  ��
'
(
' c  ��
)
*
) o  ���O�O 0 text_returned  
* m  ���N
�N 
TEXT
( o      �M�M 0 
old_prefix  
& 
+
,
+ l ��
-
.
/
- r  ��
0
1
0 l ��
2�L�K
2 I ���J�I
3�J 0 searchreplace searchReplace�I  
3 �H
4
5
�H 
into
4 o  ���G�G 0 
old_prefix  
5 �F
6
7
�F 
at  
6 m  ��
8
8 �
9
9   
7 �E
:�D�E 0 replacestring replaceString
: m  ��
;
; �
<
<  �D  �L  �K  
1 o      �C�C 0 
old_prefix  
.   remove all spaces   
/ �
=
= $   r e m o v e   a l l   s p a c e s
, 
>
?
> r  ��
@
A
@ I  ���B
B�A�B 0 upcase upCase
B 
C�@
C o  ���?�? 0 
old_prefix  �@  �A  
A o      �>�> 0 
old_prefix  
? 
D
E
D r  ��
F
G
F [  ��
H
I
H l ��
J�=�<
J I ���;
K�:
�; .corecnte****       ****
K o  ���9�9 0 
old_prefix  �:  �=  �<  
I m  ���8�8 
G o      �7�7 0 kernel_beginning  
E 
L
M
L Z  ��
N
O�6�5
N E  ��
P
Q
P o  ���4�4  0 myreservedlist myReservedList
Q o  ���3�3 0 
old_prefix  
O k  ��
R
R 
S
T
S I ���2�1�0
�2 .sysobeepnull��� ��� long�1  �0  
T 
U
V
U I ���/
W
X
�/ .sysodlogaskr        TEXT
W m  ��
Y
Y �
Z
Z W A R N I N G   - -   Y o u r   o r i g i n a l   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   T h e   p r o j e c t   i s   n o t   c l o n a b l e .   E x i t   n o w .
X �.
[�-
�. 
disp
[ m  ���,
�, stic    �-  
V 
\�+
\ l ��
]
^
_
] L  ���*�*  
^   abort program   
_ �
`
`    a b o r t   p r o g r a m�+  �6  �5  
M 
a
b
a l ���)�(�'�)  �(  �'  
b 
c
d
c l ���&
e
f�&  
e 4 . User chooses new prefix to replace old prefix   
f �
g
g \   U s e r   c h o o s e s   n e w   p r e f i x   t o   r e p l a c e   o l d   p r e f i x
d 
h
i
h T  ��
j
j k  ��
k
k 
l
m
l I ��%
n
o
�% .sysodlogaskr        TEXT
n l � 
p�$�#
p b  � 
q
r
q b  ��
s
t
s m  ��
u
u �
v
v 6 W h a t   i s   t h e   n e w   p r e f i x   f o r  
t o  ���"�"  0 newprojectname newProjectName
r m  ��
w
w �
x
x    ?  �$  �#  
o �!
y
z
�! 
dtxt
y m  
{
{ �
|
|  
z � 
}
~
�  
btns
} J  	

 
��
� m  	
�
� �
�
�  O K�  
~ �
��
� 
dflt
� m  �� �  
m 
�
�
� s  9
�
�
� c   
�
�
� l 
���
� 1  �
� 
rslt�  �  
� m  �
� 
list
� J      
�
� 
�
�
� o      �� 0 button_pressed  
� 
��
� o      �� 0 text_returned  �  
� 
�
�
� r  :E
�
�
� c  :A
�
�
� o  :=�� 0 text_returned  
� m  =@�
� 
TEXT
� o      �� 0 
new_prefix  
� 
��
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
� m  IL�� 0
� o      �� 0 n  
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
���
� ?  Zs
�
�
� l Zq
���
� I Zq�
�	
�
�
 .sysooffslong    ��� null�	  
� �
�
�
� 
psof
� l ^e
���
� I ^e�
��
� .sysontocTEXT       shor
� o  ^a�� 0 n  �  �  �  
� �
��
� 
psin
� o  hk� �  0 
new_prefix  �  �  �  
� m  qr����  
� R  v|��
���
�� .ascrerr ****      � ****
� m  x{
�
� �
�
� L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x��  �  �  
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
�� stic    ��  �  
i 
�
�
� l ����������  ��  ��  
� 
�
�
� l ����������  ��  ��  
� 
�
�
� l ����
�
���  
� / ) end of setup  //////////////////////////   
� �
�
� R   e n d   o f   s e t u p     / / / / / / / / / / / / / / / / / / / / / / / / / /
� 
�
�
� l ����������  ��  ��  
� 
�
�
� I �6��
�
�
�� .sysodlogaskr        TEXT
� l �
�����
� b  �
�
�
� b  �
�
�
� b  �
�
�
� b  �
� 
� b  � b  � b  �  m  �� � ^ T h i s   i s   w h a t   w i l l   b e   u s e d : 
 o r i g i n a l   p r o j e c t : 	 	   o  ������  0 oldprojectname oldProjectName m   		 �

   
 n e w   p r o j e c t : 	 	   o  ����  0 newprojectname newProjectName  m   � & 
 o r i g i n a l   p r e f i x : 	 	
� o  ���� 0 
old_prefix  
� m   �  
 n e w   p r e f i x : 	 	
� o  ���� 0 
new_prefix  ��  ��  
� ��
�� 
btns J  &  m   �  O K  m  ! �  R E S U B M I T �� m  !$ �  E X I T��   ��
�� 
dflt m  )*����  ����
�� 
disp m  -0��
�� stic   ��  
�  !  s  7K"#" c  7>$%$ l 7:&����& 1  7:��
�� 
rslt��  ��  % m  :=��
�� 
list# J      '' (��( o      ���� 0 buttonpressed buttonPressed��  ! )*) l LL��������  ��  ��  * +,+ Z  L�-.����- > LS/0/ o  LO���� 0 buttonpressed buttonPressed0 m  OR11 �22  E X I T. l V�3453 Z  V�678��6 = V]9:9 o  VY����  0 newprojectname newProjectName: m  Y\;; �<<  7 k  `u== >?> r  `g@A@ m  `cBB �CC  R E S U B M I TA o      ���� 0 buttonpressed buttonPressed? D��D I hu��EF
�� .sysodlogaskr        TEXTE m  hkGG �HH � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .F ��I��
�� 
dispI m  nq��
�� stic    ��  ��  8 JKJ = xLML o  x{���� 0 
old_prefix  M m  {~NN �OO  K PQP k  ��RR STS r  ��UVU m  ��WW �XX  R E S U B M I TV o      ���� 0 buttonpressed buttonPressedT Y��Y I ����Z[
�� .sysodlogaskr        TEXTZ m  ��\\ �]] � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .[ ��^��
�� 
disp^ m  ����
�� stic    ��  ��  Q _`_ = ��aba o  ������ 0 
new_prefix  b m  ��cc �dd  ` e��e k  ��ff ghg r  ��iji m  ��kk �ll  R E S U B M I Tj o      ���� 0 buttonpressed buttonPressedh m��m I ����no
�� .sysodlogaskr        TEXTn m  ��pp �qq � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .o ��r��
�� 
dispr m  ����
�� stic    ��  ��  ��  ��  4 ; 5 this checks to see if any answers were a null string   5 �ss j   t h i s   c h e c k s   t o   s e e   i f   a n y   a n s w e r s   w e r e   a   n u l l   s t r i n g��  ��  , t��t l ����������  ��  ��  ��  	N =  ( /uvu o   ( +���� 0 buttonpressed buttonPressedv m   + .ww �xx  R E S U B M I T��  ��  	K yzy l     ��������  ��  ��  z {|{ l ��}����} Z  ��~����~ = ����� o  ������ 0 buttonpressed buttonPressed� m  ���� ���  E X I T l ������ L  ������  � $  abort program by user request   � ��� <   a b o r t   p r o g r a m   b y   u s e r   r e q u e s t��  ��  ��  ��  | ��� l     ��������  ��  ��  � ��� l     ������  �  ////// end of User Input   � ��� 0 / / / / / /   e n d   o f   U s e r   I n p u t� ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  � / ) Duplicate original Xcode project folder    � ��� R   D u p l i c a t e   o r i g i n a l   X c o d e   p r o j e c t   f o l d e r  � ��� l �������� O  ����� r  ����� I �����~
� .coreclon****      � ****� o  ���}�} 0 	thefolder 	theFolder�~  � o      �|�| 0 	newfolder 	newFolder� m  �����                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  ��  ��  � ��� l     �{�z�y�{  �z  �y  � ��� l     �x���x  � = 7 set POSIX path for duplicated Folder for shell scripts   � ��� n   s e t   P O S I X   p a t h   f o r   d u p l i c a t e d   F o l d e r   f o r   s h e l l   s c r i p t s� ��� l ���w�v� r  ���� c  ����� b  ����� b  ����� o  ���u�u 0 myhome myHome� o  ���t�t  0 oldprojectname oldProjectName� m  ���� ���    c o p y /� m  ���s
�s 
TEXT� o      �r�r 0 mypath myPath�w  �v  � ��� l     �q�p�o�q  �p  �o  � ��� l     �n���n  �   create new project   � ��� &   c r e a t e   n e w   p r o j e c t� ��� l     �m���m  � ) # Launch ProgBar for the first time.   � ��� F   L a u n c h   P r o g B a r   f o r   t h e   f i r s t   t i m e .� ��� l     �l���l  �  startProgBar() of me   � ��� ( s t a r t P r o g B a r ( )   o f   m e� ��� l     �k�j�i�k  �j  �i  � ��� l T��h�g� O  T��� k  S�� ��� l �f�e�d�f  �e  �d  � ��� l �c���c  � U O clean out duplicated project build folder before making list of project items    � ��� �   c l e a n   o u t   d u p l i c a t e d   p r o j e c t   b u i l d   f o l d e r   b e f o r e   m a k i n g   l i s t   o f   p r o j e c t   i t e m s  � ��� r  ��� c  ��� o  �b�b 0 	newfolder 	newFolder� m  �a
�a 
ctxt� o      �`�` 0 mybuildpath myBuildPath� ��_� Q  S���^� k  J�� ��� r  )��� c  %��� b  !��� o  �]�] 0 mybuildpath myBuildPath� m   �� ��� 
 b u i l d� m  !$�\
�\ 
alis� o      �[�[ 0 mybuildpath myBuildPath� ��Z� Z  *J���Y�X� > *8��� l *5��W�V� I *5�U��
�U .earslfdrutxt  @    file� o  *-�T�T 0 mybuildpath myBuildPath� �S��R
�S 
lfiv� m  01�Q
�Q boovfals�R  �W  �V  � J  57�P�P  � I ;F�O��N
�O .coredelonull���     obj � n  ;B��� 2 >B�M
�M 
cobj� o  ;>�L�L 0 mybuildpath myBuildPath�N  �Y  �X  �Z  � R      �K�J�I
�K .ascrerr ****      � ****�J  �I  �^  �_  � m  ���                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �h  �g  � ��� l Up���� I  Up�H��G�H 0 doonefolder doOneFolder� ��� o  VY�F�F 0 	newfolder 	newFolder� ��� o  Y\�E�E 0 mybuildpath myBuildPath�    o  \_�D�D 0 
old_prefix    o  _b�C�C 0 
new_prefix    o  bg�B�B  0 oldprojectname oldProjectName �A o  gj�@�@  0 newprojectname newProjectName�A  �G  � &   process all folders recursively   � � @   p r o c e s s   a l l   f o l d e r s   r e c u r s i v e l y� 	 l q�

 O  q� k  w�  l w� r  w� o  wz�?�?  0 newprojectname newProjectName n       1  }��>
�> 
pnam o  z}�=�= 0 	newfolder 	newFolder : 4 finally rename duplicate folder to new project name    � h   f i n a l l y   r e n a m e   d u p l i c a t e   f o l d e r   t o   n e w   p r o j e c t   n a m e �< l ���;�;   _ YstopProgBar() of me -- Conclude the progress bar. This 'resets' the progress bar's state.    � � s t o p P r o g B a r ( )   o f   m e   - -   C o n c l u d e   t h e   p r o g r e s s   b a r .   T h i s   ' r e s e t s '   t h e   p r o g r e s s   b a r ' s   s t a t e .�<   m  qt�                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��   0 * end finder script for renaming everything    � T   e n d   f i n d e r   s c r i p t   f o r   r e n a m i n g   e v e r y t h i n g	  !  l     �:�9�8�:  �9  �8  ! "#" l     �7$%�7  $ � z Go into Project .xcodeproj package and replace all prefixes and names to fix broken links within xcode paths and targets    % �&& �   G o   i n t o   P r o j e c t   . x c o d e p r o j   p a c k a g e   a n d   r e p l a c e   a l l   p r e f i x e s   a n d   n a m e s   t o   f i x   b r o k e n   l i n k s   w i t h i n   x c o d e   p a t h s   a n d   t a r g e t s  # '(' l ��)�6�5) r  ��*+* c  ��,-, b  ��./. b  ��010 b  ��232 b  ��454 o  ���4�4 0 myhome myHome5 o  ���3�3  0 newprojectname newProjectName3 m  ��66 �77  /1 o  ���2�2  0 newprojectname newProjectName/ m  ��88 �99  . x c o d e p r o j- m  ���1
�1 
TEXT+ o      �0�0 0 mypath myPath�6  �5  ( :;: l ��<=>< r  ��?@? m  ��AA �BB  . p b x p r o j@ o      �/�/ 0 
filesuffix 
fileSuffix=   set global variable   > �CC (   s e t   g l o b a l   v a r i a b l e; DED l     �.�-�,�.  �-  �,  E FGF l ��H�+�*H I  ���)I�(�) &0 simplereplacetext simpleReplaceTextI JKJ m  ��LL �MM  p r o j e c t . p b x p r o jK NON o  ���'�'  0 oldprojectname oldProjectNameO P�&P o  ���%�%  0 newprojectname newProjectName�&  �(  �+  �*  G QRQ l     �$�#�"�$  �#  �"  R STS l     �!UV�!  U _ Y --------more detailed search of project file structure to prevent incorrect replacements   V �WW �   - - - - - - - - m o r e   d e t a i l e d   s e a r c h   o f   p r o j e c t   f i l e   s t r u c t u r e   t o   p r e v e n t   i n c o r r e c t   r e p l a c e m e n t sT XYX l ��Z� �Z r  ��[\[ c  ��]^] b  ��_`_ m  ��aa �bb  p a t h   =  ` o  ���� 0 
old_prefix  ^ m  ���
� 
TEXT\ o      �� 0 pathoprefix  �   �  Y cdc l ��e��e r  ��fgf c  ��hih b  ��jkj m  ��ll �mm  p a t h   =  k o  ���� 0 
new_prefix  i m  ���
� 
TEXTg o      �� 0 pathnprefix  �  �  d non l ��p��p I  ���q�� &0 simplereplacetext simpleReplaceTextq rsr m  ��tt �uu  p r o j e c t . p b x p r o js vwv o  ���� 0 pathoprefix  w x�x o  ���� 0 pathnprefix  �  �  �  �  o yzy l     ����  �  �  z {|{ l ��}��} r  ��~~ c  ����� b  ����� m  ���� ���  n a m e   =  � o  ���
�
 0 
old_prefix  � m  ���	
�	 
TEXT o      �� 0 nameoprefix  �  �  | ��� l ����� r  ���� c  �	��� b  ���� m  ��� ���  n a m e   =  � o  �� 0 
new_prefix  � m  �
� 
TEXT� o      �� 0 namenprefix  �  �  � ��� l ���� I  � ����  &0 simplereplacetext simpleReplaceText� ��� m  �� ���  p r o j e c t . p b x p r o j� ��� o  ���� 0 nameoprefix  � ���� o  ���� 0 namenprefix  ��  ��  �  �  � ��� l     ��������  ��  ��  � ��� l ,������ r  ,��� c  (��� b  $��� m   �� ���  H E A D E R   =  � o   #���� 0 
old_prefix  � m  $'��
�� 
TEXT� o      ���� 0 nameoprefix  ��  ��  � ��� l -<������ r  -<��� c  -8��� b  -4��� m  -0�� ���  H E A D E R   =  � o  03���� 0 
new_prefix  � m  47��
�� 
TEXT� o      ���� 0 namenprefix  ��  ��  � ��� l =K������ I  =K������� &0 simplereplacetext simpleReplaceText� ��� m  >A�� ���  p r o j e c t . p b x p r o j� ��� o  AD���� 0 nameoprefix  � ���� o  DG���� 0 namenprefix  ��  ��  ��  ��  � ��� l     ��������  ��  ��  � ��� l Le������ r  Le��� c  La��� b  L]��� b  LY��� b  LU��� m  LO�� ���  p a t h   =  � o  OT���� 0 	nibfolder 	nibFolder� m  UX�� ���  \ /� o  Y\���� 0 
old_prefix  � m  ]`��
�� 
TEXT� o      ���� 0 nibpathoprefix  ��  ��  � ��� l f������ r  f��� c  f{��� b  fw��� b  fs��� b  fo��� m  fi�� ���  p a t h   =  � o  in���� 0 	nibfolder 	nibFolder� m  or�� ���  \ /� o  sv���� 0 
new_prefix  � m  wz��
�� 
TEXT� o      ���� 0 nibpathnprefix  ��  ��  � ��� l �������� I  ��������� &0 simplereplacetext simpleReplaceText� ��� m  ���� ���  p r o j e c t . p b x p r o j� ��� o  ������ 0 nibpathoprefix  � ���� o  ������ 0 nibpathnprefix  ��  ��  ��  ��  � ��� l     ��������  ��  ��  � ��� l �������� r  ����� c  ����� b  ����� b  ����� b  ����� m  ���� ���  n a m e   =  � o  ������ 0 	nibfolder 	nibFolder� m  ���� �    \ /� o  ������ 0 
old_prefix  � m  ����
�� 
TEXT� o      ���� 0 nibpathoprefix  ��  ��  �  l ������ r  �� c  �� b  ��	 b  ��

 b  �� m  �� �  n a m e   =   o  ������ 0 	nibfolder 	nibFolder m  �� �  \ /	 o  ������ 0 
new_prefix   m  ����
�� 
TEXT o      ���� 0 nibpathnprefix  ��  ��    l ������ I  �������� &0 simplereplacetext simpleReplaceText  m  �� �  p r o j e c t . p b x p r o j  o  ������ 0 nibpathoprefix   �� o  ������ 0 nibpathnprefix  ��  ��  ��  ��    l     ��������  ��  ��     l ��!����! r  ��"#" c  ��$%$ b  ��&'& b  ��()( b  ��*+* m  ��,, �--  p a t h   =  + o  ������ 0 	xibfolder 	xibFolder) m  ��.. �//  \ /' o  ������ 0 
old_prefix  % m  ����
�� 
TEXT# o      ���� 0 xibpathoprefix  ��  ��    010 l �2����2 r  �343 c  �565 b  ��787 b  ��9:9 b  ��;<; m  ��== �>>  p a t h   =  < o  ������ 0 	xibfolder 	xibFolder: m  ��?? �@@  \ /8 o  ������ 0 
new_prefix  6 m  � ��
�� 
TEXT4 o      ���� 0 xibpathnprefix  ��  ��  1 ABA l C����C I  ��D���� &0 simplereplacetext simpleReplaceTextD EFE m  
GG �HH  p r o j e c t . p b x p r o jF IJI o  
���� 0 xibpathoprefix  J K��K o  ���� 0 xibpathnprefix  ��  ��  ��  ��  B LML l     ��������  ��  ��  M NON l .P����P r  .QRQ c  *STS b  &UVU b  "WXW b  YZY m  [[ �\\  n a m e   =  Z o  ���� 0 matlabfolder matlabFolderX m  !]] �^^  \ /V o  "%���� 0 
old_prefix  T m  &)��
�� 
TEXTR o      ���� &0 matlabpathoprefix matlabPathoprefix��  ��  O _`_ l /Ha����a r  /Hbcb c  /Dded b  /@fgf b  /<hih b  /8jkj m  /2ll �mm  n a m e   =  k o  27���� 0 matlabfolder matlabFolderi m  8;nn �oo  \ /g o  <?���� 0 
new_prefix  e m  @C��
�� 
TEXTc o      ���� &0 matlabpathnprefix matlabPathnprefix��  ��  ` pqp l IWr����r I  IW��s���� &0 simplereplacetext simpleReplaceTexts tut m  JMvv �ww  p r o j e c t . p b x p r o ju xyx o  MP���� &0 matlabpathoprefix matlabPathoprefixy z��z o  PS���� &0 matlabpathnprefix matlabPathnprefix��  ��  ��  ��  q {|{ l     ��������  ��  ��  | }~} l     �����     clean new project   � ��� $   c l e a n   n e w   p r o j e c t~ ��� l Xm������ r  Xm��� c  Xg��� b  Xc��� b  X_��� o  X[���� 0 myhome myHome� o  [^����  0 newprojectname newProjectName� m  _b�� ���  /� m  cf��
�� 
TEXT� o      ���� 0 mypath myPath��  ��  � ��� l n����� r  n���� l n������� I n�������� 0 searchreplace searchReplace��  � ����
�� 
into� o  rw���� 0 mypath myPath� ���
� 
at  � l z}��~�}� m  z}�� ���   �~  �}  � �|��{�| 0 replacestring replaceString� m  ���� ���  \ %�{  ��  ��  � o      �z�z 0 	shellpath 	ShellPath� H B uses global variable to overcome POSIX issue with spaces in names   � ��� �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s� ��� l ����y�x� r  ����� l ����w�v� I ���u�t��u 0 searchreplace searchReplace�t  � �s��
�s 
into� o  ���r�r 0 	shellpath 	ShellPath� �q��
�q 
at  � m  ���� ���  %� �p��o�p 0 replacestring replaceString� m  ���� ���   �o  �w  �v  � o      �n�n 0 	shellpath 	ShellPath�y  �x  � ��� l     �m���m  � h bset cmd to "rm " & ShellPath & replaceScriptName -- remove sed script file from new project folder   � ��� � s e t   c m d   t o   " r m   "   &   S h e l l P a t h   &   r e p l a c e S c r i p t N a m e   - -   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e r� ��� l     �l���l  �  do shell script cmd   � ��� & d o   s h e l l   s c r i p t   c m d� ��� l ����k�j� r  ����� b  ����� b  ����� m  ���� ���  c d  � o  ���i�i 0 	shellpath 	ShellPath� m  ���� ��� < ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a n� o      �h�h 0 cmd  �k  �j  � ��� l ����g�f� I ���e��d
�e .sysoexecTEXT���     TEXT� o  ���c�c 0 cmd  �d  �g  �f  � ��� l     �b�a�`�b  �a  �`  � ��� l     �_���_  �   end of copyXproject   � ��� (   e n d   o f   c o p y X p r o j e c t� ��� l ����^�]� I ���\�[�Z
�\ .miscactvnull��� ��� null�[  �Z  �^  �]  � ��� l ����Y�X� I ���W��
�W .sysodlogaskr        TEXT� b  ����� o  ���V�V  0 newprojectname newProjectName� m  ���� ��� $   h a s   b e e n   c r e a t e d !� �U��T
�U 
disp� m  ���S
�S stic   �T  �Y  �X  � ��� l     �R�Q�P�R  �Q  �P  � ��O� l     �N�M�L�N  �M  �L  �O       ^�K� > G P Y��A����������������������J�I��� �H�G	
��F�E�D�C�B�A�@�?�>�=�<�;�:�9�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!� ��K  � \���������������������
�	��������� ��������������������������������������������������������������������������������������������������������������������������� 0 	nibfolder 	nibFolder� 0 	xibfolder 	xibFolder� 0 matlabfolder matlabFolder� &0 replacescriptname replaceScriptName�  0 oldprojectname oldProjectName� 0 mypath myPath� 0 
filesuffix 
fileSuffix� 0 doonefolder doOneFolder� &0 replacetextinfile replaceTextInFile� &0 simplereplacetext simpleReplaceText� 0 searchreplace searchReplace� 0 upcase upCase�  0 prepareprogbar prepareProgBar� $0 incrementprogbar incrementProgBar� 0 fadeinprogbar fadeinProgBar�  0 fadeoutprogbar fadeoutProgBar� 0 showprogbar showProgBar� 0 hideprogbar hideProgBar� 0 
barberpole 
barberPole�  0 killbarberpole killBarberPole�
 0 startprogbar startProgBar�	 0 stopprogbar stopProgBar
� .aevtoappnull  �   � ****�  0 myreservedlist myReservedList� 0 buttonpressed buttonPressed� 0 	thefolder 	theFolder� 0 olddelimiter oldDelimiter� 0 myhome myHome� 0 totl  � 
0 ending  �  0 button_pressed  �� 0 text_returned  ��  0 newprojectname newProjectName�� 0 
old_prefix  �� 0 kernel_beginning  �� 0 
new_prefix  �� 0 n  �� 0 	newfolder 	newFolder�� 0 mybuildpath myBuildPath�� 0 filelist fileList�� 0 pathoprefix  �� 0 pathnprefix  �� 0 nameoprefix  �� 0 namenprefix  �� 0 nibpathoprefix  �� 0 nibpathnprefix  �� 0 xibpathoprefix  �� 0 xibpathnprefix  �� &0 matlabpathoprefix matlabPathoprefix�� &0 matlabpathnprefix matlabPathnprefix�� 0 	shellpath 	ShellPath�� 0 cmd  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  � �   S i g n a l D e t e c t i o n 4� � Z / U s e r s / S h a r e d / L a b l i b / L a b l i b - P l u g i n s / S D K e r n e l /� �� ��������� 0 doonefolder doOneFolder�� ����   �������������� 0 	thefolder 	theFolder�� 0 	buildpath 	buildPath�� 0 
old_prefix  �� 0 
new_prefix  ��  0 oldprojectname oldProjectName��  0 newprojectname newProjectName��   �������������������������������� 0 	thefolder 	theFolder�� 0 	buildpath 	buildPath�� 0 
old_prefix  �� 0 
new_prefix  ��  0 oldprojectname oldProjectName��  0 newprojectname newProjectName�� 0 
folderlist 
folderList�� 0 f  �� 0 numfiles numFiles�� 0 n  �� 0 currentfile currentFile�� &0 pathtocurrentfile pathToCurrentFile�� 0 filename_kernel  �� 0 testchar testChar�� 
0 locase   B��������������������������������%GMY|�����������������.��������������y���������%-:Vai�
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
�� .corecnte****       ****�� 0 kernel_beginning  �� &0 replacetextinfile replaceTextInFile
�� 
docf
�� .sysoctonshor       TEXT�� A�� Z
�� 
bool��  
�� .sysontocTEXT       shor�� &0 simplereplacetext simpleReplaceText
�� 
into
�� 
at  �� 0 replacestring replaceString�� 0 searchreplace searchReplace���� 
��-�,EE�UO 'k��,Ekh *��&��/%�&������+ OP[OY��O����-�,EE�O�j O�E�O�k�kh 	��/EE�O��&��/%E�O��窤 ?�E�O Ϊj kh 	���/%E�[OY��O)��&������+ O��%�a �/�,FY��a  �a %�a �/�,FY��a  �a %�a �/�,FYl�a  /)��&������+ O��a %  �a %�a �/�,FY hY7�a  J)��&������+ O��a %  �a %�a �/�,FY ��a %  �a %�a �/�,FY hY 窤a %  �a %��b   /a �/�,FY Ū�a %  !)��&������+ O�a  %�a �/�,FY ��a ! �a "Ec  O)��&������+ O��k/j #E�O�a $	 �a %a && 4a 'E�O l�j kh 	���/%E�[OY��O�a (j )�%E�Y hO)���m+ *O)a +�a ,�a -�� .�a �/�,FY hOPY��a / �a 0%�a �/�,FY~�a 1 �a 2%�a �/�,FYe�a 3 /)��&������+ O��a 4%  �a 5%�a �/�,FY hY0�a 6 J)��&������+ O��a 7%  �a 8%�a �/�,FY ��a 9%  �a :%�a �/�,FY hY તa ;%  �a <%�a �/�,FY Ū�a =%  !)��&������+ O�a >%�a �/�,FY ��a ? �a @Ec  O)��&������+ O��k/j #E�O�a $	 �a %a && 4a AE�O l�j kh 	���/%E�[OY��O�a (j )�%E�Y hO)���m+ *O)a +�a ,�a -�� .�a �/�,FY h[OY�gOPU� ����������� &0 replacetextinfile replaceTextInFile�� ����   �������������� 0 	thefolder 	theFolder�� 0 thefile theFile�� 0 oldtext1  �� 0 newtext1  �� 0 oldtext2  �� 0 newtext2  ��   ����������~�}�|�{�z�y�x�� 0 	thefolder 	theFolder�� 0 thefile theFile�� 0 oldtext1  �� 0 newtext1  � 0 oldtext2  �~ 0 newtext2  �} 0 tempfile tempFile�| 0 myfolderpath myFolderPath�{ 0 filename fileName�z 0 fileid fileID�y 0 	shellpath 	ShellPath�x 0 cmd   4��w�v�u�t�s8:<�r�q@BFHJN�p�o�n�m�lo�kr�j�i�������������h4
�w 
psxp
�v 
TEXT
�u 
psxf
�t 
perm
�s .rdwropenshor       file�r 

�q .sysontocTEXT       shor
�p 
refn
�o .rdwrwritnull���     ****
�n .rdwrclosnull���     ****
�m 
into
�l 
at  �k 0 replacestring replaceString�j �i 0 searchreplace searchReplace
�h .sysoexecTEXT���     TEXT��Q�E�O��,�&E�O�b  %E�O*�/�el E�O�%�%�%�%�j 
%�%�%�%�j 
%�%�%�%�%�%�j 
%a %a �l O�j O��,�&E�O*a �a a a a a  E�O*a �a a a a a  E�Oa �%�%a %�%�%a %a  %�%�%a !%a "%�%a #%�%a $%�%�%a %%�%�%a &%a '%�%�%E�O�j (Oa )�%�%a *%�%�%a +%a ,%�%�%a -%a .%�%b  %a /%�%�%a 0%�%�%a 1%a 2%�%�%E�O�j (Oa 3�%b  %E�O�j (� �gC�f�e�d�g &0 simplereplacetext simpleReplaceText�f �c�c   �b�a�`�b 0 thefile theFile�a 0 oldtext  �` 0 newtext newText�e   �_�^�]�\�[�Z�_ 0 thefile theFile�^ 0 oldtext  �] 0 newtext newText�\ 0 tempfile tempFile�[ 0 	shellpath 	ShellPath�Z 0 cmd   V�Y�X�Wg�Vj�U�Twz����������S
�Y 
TEXT
�X 
into
�W 
at  �V 0 replacestring replaceString�U �T 0 searchreplace searchReplace
�S .sysoexecTEXT���     TEXT�d `�b  %�&E�O*�b  ����� E�O*������ E�O�%�%�%�%�%�%�%�%�%a %�%a %�%a %�%a %�%E�O�j � �R��Q�P�O�R 0 searchreplace searchReplace�Q  �P �N�M
�N 
into�M 0 
mainstring 
mainString �L�K
�L 
at  �K 0 searchstring searchString �J�I�H�J 0 replacestring replaceString�I 0 replacestring replaceString�H   �G�F�E�D�C�B�G 0 
mainstring 
mainString�F 0 searchstring searchString�E 0 replacestring replaceString�D 0 foundoffset foundOffset�C 0 stringstart stringStart�B 0 	stringend 	stringEnd �A�@�?�>��=�<
�A 
psof
�@ 
psin�? 
�> .sysooffslong    ��� null
�= 
ctxt
�< .corecnte****       ****�O T Oh��*��� E�O�k  �E�Y �[�\[Zk\Z�k2E�O�[�\[Z��j \Zi2E�O��%�%E�[OY��O�� �;*�:�9 �8�; 0 upcase upCase�: �7!�7 !  �6�6 0 astring aString�9   �5�4�3�2�5 0 astring aString�4 
0 buffer  �3 0 i  �2 0 testchar testChar  	2�1�0�/�.�-�,�+�*
�1 .corecnte****       ****
�0 
cobj
�/ .sysoctonshor       TEXT�. a�- z
�, 
bool�+  
�* .sysontocTEXT       shor�8 Q�E�O Hk�j kh ��/j E�O��	 ���& ���j %E�OPY ��j %E�OPOP[OY��O�� �)��(�'"#�&�)  0 prepareprogbar prepareProgBar�( �%$�% $  �$�#�$ 0 somemaxcount someMaxCount�# 0 
windowname 
windowName�'  " �"�!�" 0 somemaxcount someMaxCount�! 0 
windowname 
windowName# �� ������������������    ��
� 
cwin
� 
bacC
� 
hasS� � � � e��� 
� 
cobj
� 
levV
� 
titl
� 
proI
� 
conT
� 
minW
� 
maxV�& b� ^���mv*�/�,FOe*�/�,FOjm������v��/*�/�,FO�*�/�,FOj*�/�k/a ,FOj*�/�k/a ,FO�*�/�k/a ,FU� ����%&�� $0 incrementprogbar incrementProgBar� �'� '  �
�	��
 0 
itemnumber 
itemNumber�	 0 somemaxcount someMaxCount� 0 
windowname 
windowName�  % ���� 0 
itemnumber 
itemNumber� 0 somemaxcount someMaxCount� 0 
windowname 
windowName& 
+����� ��� 0 filelist fileList
� 
cobj
� 
cwin
� 
titl
�  
proI
�� 
conT� '� #�%�%�%�%��/%*�/�,FO�*�/�k/�,FU� ��6����()���� 0 fadeinprogbar fadeinProgBar�� ��*�� *  ���� 0 
windowname 
windowName��  ( �������� 0 
windowname 
windowName�� 0 	fadevalue 	fadeValue�� 0 i  ) 
n��������R��������
�� 
cwin
�� .appScent****      � ****
�� 
alpV
�� 
pvis�� 	
�� 
proI
�� 
usTA
�� .coVSstaA****      � ****�� P� L*�/j Oj*�/�,FOe*�/�,FO�E�O j�kh �*�/�,FO��E�[OY��O*�/�k/�el 	U� ��y����+,����  0 fadeoutprogbar fadeoutProgBar�� ��-�� -  ���� 0 
windowname 
windowName��  + �������� 0 
windowname 
windowName�� 0 	fadevalue 	fadeValue�� 0 i  , 
�����������������
�� 
cwin
�� 
proI
�� 
usTA
�� .coVSstoT****      � ****�� 	
�� 
alpV
�� 
pvis�� >� :*�/�k/�el O�E�O k�kh �*�/�,FO��E�[OY��Of*�/�,FU� �������./���� 0 showprogbar showProgBar�� ��0�� 0  ���� 0 
windowname 
windowName��  . ���� 0 
windowname 
windowName/ �������������
�� 
cwin
�� .appScent****      � ****
�� 
pvis
�� 
proI
�� 
usTA
�� .coVSstaA****      � ****�� %� !*�/j Oe*�/�,FO*�/�k/�el U� �������12���� 0 hideprogbar hideProgBar�� ��3�� 3  ���� 0 
windowname 
windowName��  1 ���� 0 
windowname 
windowName2 �����������
�� 
cwin
�� 
proI
�� 
usTA
�� .coVSstoT****      � ****
�� 
pvis�� � *�/�k/�el Of*�/�,FU� �������45���� 0 
barberpole 
barberPole�� ��6�� 6  ���� 0 
windowname 
windowName��  4 ���� 0 
windowname 
windowName5 	������
�� 
cwin
�� 
proI
�� 
indR�� � e*�/�k/�,FU� ��	����78����  0 killbarberpole killBarberPole�� ��9�� 9  ���� 0 
windowname 
windowName��  7 ���� 0 
windowname 
windowName8 	������
�� 
cwin
�� 
proI
�� 
indR�� � f*�/�k/�,FU� ��	%����:;���� 0 startprogbar startProgBar��  ��  :  ; 	(��
�� .ascrnoop****      � ****�� � *j U� ��	3����<=���� 0 stopprogbar stopProgBar��  ��  <  = 	6��
�� .aevtquitnull��� ��� null�� � *j U� ��>����?@��
�� .aevtoappnull  �   � ****> k    �AA  �BB 	@CC 	JDD {EE �FF �GG �HH �II JJ 'KK :LL FMM XNN cOO nPP {QQ �RR �SS �TT �UU �VV �WW �XX �YY �ZZ [[ \\ ]] 0^^ A__ N`` _aa pbb �cc �dd �ee �ff �gg �hh �����  ��  ��  ?  @ � � � � � � � � � � � � � � � � � �����	G��w��	^����������������������	���������	�	���	���	���	�����������������������	���	��



�~
8
;�}�|�{
Y�z�y
u
w
{
��x�w�v�u�t�s�r�q�p
�
�
�
��o
�	�n1;BGNW\ckp���m�l��k�j��i�h�g�f68AL�ea�dl�ct��b��a�������`���_���,.�^=?�]G[]�\ln�[v����Z�����Y�X�W��� ��  0 myreservedlist myReservedList�� 0 buttonpressed buttonPressed
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
at  �� 0 replacestring replaceString� 0 searchreplace searchReplace�~ 0 
old_prefix  �} 0 upcase upCase�| 0 kernel_beginning  
�{ .sysobeepnull��� ��� long
�z 
disp
�y stic    �x 0 
new_prefix  �w 0�v 0 n  �u 

�t 
psof
�s .sysontocTEXT       shor
�r 
psin�q 
�p .sysooffslong    ��� null�o  
�n stic   
�m .coreclon****      � ****�l 0 	newfolder 	newFolder
�k 
ctxt�j 0 mybuildpath myBuildPath
�i 
lfiv
�h .earslfdrutxt  @    file
�g .coredelonull���     obj �f 0 doonefolder doOneFolder�e &0 simplereplacetext simpleReplaceText�d 0 pathoprefix  �c 0 pathnprefix  �b 0 nameoprefix  �a 0 namenprefix  �` 0 nibpathoprefix  �_ 0 nibpathnprefix  �^ 0 xibpathoprefix  �] 0 xibpathnprefix  �\ &0 matlabpathoprefix matlabPathoprefix�[ &0 matlabpathnprefix matlabPathnprefix�Z 0 	shellpath 	ShellPath�Y 0 cmd  
�X .sysoexecTEXT���     TEXT
�W .miscactvnull��� ��� null�������������������a a vE` Oa E` O�h_ a  *a a l a &E` O_ j a ,Ec  O p_ a ,E` O_ a  ,a !&E` "Oa #_ a ,FO_ "a $-j %E` &O_ &lE` 'O_ "[a $\[Zk\Z_ '2a !&a (%E` "O_ _ a ,FW X ) *_ _ a ,FOa +a ,a -a .a /kva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` 8O*a 9_ 8a :a ;a <a =a 1 >E` 8Oa ?b  %a @%a ,a Aa .a Bkva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` CO*a 9_ Ca :a Da <a Ea 1 >E` CO*_ Ck+ FE` CO_ Cj %kE` GO_ _ C *j HOa Ia Ja Kl 2OhY hOhZa L_ 8%a M%a ,a Na .a Okva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` PO �a QE` RO =a Skh*a T_ Rj Ua V_ Pa W Xj )ja YY hO_ RkE` R[OY��O*a 9_ Pa :a Za <a [a 1 >E` PO*_ Pk+ FE` PO_ _ P *j HOa \a Ja Kl 2Y W X ] *a ^a Ja Kl 2[OY� Oa _b  %a `%_ 8%a a%_ C%a b%_ P%a .a ca da emva 0ka Ja fa 1 2O_ 3a 4&E[a 5k/EQ` ZO_ a g l_ 8a h  a iE` Oa ja Ja Kl 2Y G_ Ca k  a lE` Oa ma Ja Kl 2Y %_ Pa n  a oE` Oa pa Ja Kl 2Y hY hOP[OY�bO_ a q  hY hOa r _ j sE` tUO_ "b  %a u%a !&Ec  Oa r J_ ta v&E` wO 5_ wa x%a &E` wO_ wa yfl zjv _ wa 5-j {Y hW X ] *hUO*_ t_ w_ C_ Pb  _ 8a 1+ |Oa r _ 8_ ta ,FOPUO_ "_ 8%a }%_ 8%a ~%a !&Ec  Oa Ec  O*a �b  _ 8m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b  %a �%_ C%a !&E` �Oa �b  %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b  %a �%_ C%a !&E` �Oa �b  %a �%_ P%a !&E` �O*a �_ �_ �m+ �O_ "_ 8%a �%a !&Ec  O*a 9b  a :a �a <a �a 1 >E` �O*a 9_ �a :a �a <a �a 1 >E` �Oa �_ �%a �%E` �O_ �j �O*j �O_ 8a �%a Ja fl 2� �Vi�V i   � � � � � � � � � � � � � � � � �� �jj  O K�Jalis    F  JHRM                           BD ����SignalDetection4                                               ����            ����  J cu            6/:Users:Shared:Lablib:Lablib-Plugins:SignalDetection4/  "  S i g n a l D e t e c t i o n 4  
  J H R M  3Users/Shared/Lablib/Lablib-Plugins/SignalDetection4   / ��  � �Uk�U k  ll �mm  � �nn H / U s e r s / S h a r e d / L a b l i b / L a b l i b - P l u g i n s /�J �I � �oo  O K� �pp  S D K� �qq  S D K e r n e l  �rr  S D 4�H  �ss  S D K�G : tt u�Tvu w�Sxw y�Rzy {�Q|{ }�P~} ��O
�O 
sdsk
�P 
cfol~ � 
 U s e r s
�Q 
cfol| ���  S h a r e d
�R 
cfolz ���  L a b l i b
�S 
cfolx ���  L a b l i b - P l u g i n s
�T 
cfolv ��� * S i g n a l D e t e c t i o n 4   c o p y ��� | J H R M : U s e r s : S h a r e d : L a b l i b : L a b l i b - P l u g i n s : S i g n a l D e t e c t i o n 4   c o p y : �N��N G� G ������������������������������������������������������������������������ ���  I n f o . p l i s t� ���  N o t e s . t x t� ��� " P l u g i n - I n f o . p l i s t� ��� 
 S D S . h� ��� . S D S B e h a v i o r C o n t r o l l e r . h� ��� . S D S B e h a v i o r C o n t r o l l e r . m� ��� " S D S B l o c k e d S t a t e . h� ��� " S D S B l o c k e d S t a t e . m� ���  S D S C u e S t a t e . h� ���  S D S C u e S t a t e . m� ���  S D S D i g i t a l O u t . h� ���  S D S D i g i t a l O u t . m� ��� $ S D S E n d t r i a l S t a t e . h� ��� $ S D S E n d t r i a l S t a t e . m� ��� ( S D S E y e X Y C o n t r o l l e r . h� ��� ( S D S E y e X Y C o n t r o l l e r . m� ��� $ S D S F i x G r a c e S t a t e . h� ��� $ S D S F i x G r a c e S t a t e . m� ���   S D S F i x a t e S t a t e . h� ���   S D S F i x a t e S t a t e . m� ���   S D S F i x o f f S t a t e . h� ���   S D S F i x o f f S t a t e . m� ���  S D S F i x o n S t a t e . h� ���  S D S F i x o n S t a t e . m� ���  S D S I d l e S t a t e . h� ���  S D S I d l e S t a t e . m� ��� ( S D S I n t e r t r i a l S t a t e . h� ��� ( S D S I n t e r t r i a l S t a t e . m� ��� * S D S M a t l a b C o n t r o l l e r . h� ��� * S D S M a t l a b C o n t r o l l e r . m� ��� ( S D S P o s t S a m p l e S t a t e . h� ��� ( S D S P o s t S a m p l e S t a t e . m� ���   S D S P r e C u e S t a t e . m� ��� " S D S P r e s t i m S t a t e . h� ��� " S D S P r e s t i m S t a t e . m� ���  S D S R e a c t S t a t e . h� ���  S D S R e a c t S t a t e . m� ��� * S D S R o u n d T o S t i m C y c l e . h� ��� * S D S R o u n d T o S t i m C y c l e . m� ��� " S D S S a c c a d e S t a t e . h� ��� " S D S S a c c a d e S t a t e . m� ���   S D S S a m p l e S t a t e . h� ���   S D S S a m p l e S t a t e . m� ��� * S D S S i g n a l C o n t r o l l e r . h� ��� * S D S S i g n a l C o n t r o l l e r . m� ��� ( S D S S p i k e C o n t r o l l e r . h� ��� ( S D S S p i k e C o n t r o l l e r . m� ��� ( S D S S t a r t t r i a l S t a t e . h� ��� ( S D S S t a r t t r i a l S t a t e . m� ���   S D S S t a t e S y s t e m . h� ���   S D S S t a t e S y s t e m . m� �    S D S S t i m u l i . h� �  S D S S t i m u l i . m� �  S D S S t o p S t a t e . h� �  S D S S t o p S t a t e . m� � , S D S S u m m a r y C o n t r o l l e r . h� � , S D S S u m m a r y C o n t r o l l e r . m� � * S D S T a r g e t S p o t s S t a t e . h� � * S D S T a r g e t S p o t s S t a t e . m� �  S D S T e s t S t a t e . h� �		  S D S T e s t S t a t e . m� �

  S D S U t i l i t i e s . h� �  S D S U t i l i t i e s . m� � " S D S X T C o n t r o l l e r . h� � " S D S X T C o n t r o l l e r . m� � $ S i g n a l D e t e c t i o n 4 . h� � $ S i g n a l D e t e c t i o n 4 . m� � 4 S i g n a l D e t e c t i o n 4 . x c o d e p r o j� � 2 S i g n a l D e t e c t i o n 4 _ P r e f i x . h� � $ U s e r D e f a u l t s . p l i s t� �  m a i n . m �  p a t h   =   S D 4 �  p a t h   =   S D K �  H E A D E R   =   S D 4 �  H E A D E R   =   S D K	 � 2 n a m e   =   E n g l i s h . l p r o j \ / S D 4
 � 2 n a m e   =   E n g l i s h . l p r o j \ / S D K � , p a t h   =   B a s e . l p r o j \ / S D 4 � , p a t h   =   B a s e . l p r o j \ / S D K � $ n a m e   =   M a t l a b \ / S D 4 � $ n a m e   =   M a t l a b \ / S D K � � c d   / U s e r s / S h a r e d / L a b l i b / L a b l i b - P l u g i n s / S D K e r n e l / ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a n�F  �E  �D  �C  �B  �A  �@  �?  �>  �=  �<  �;  �:  �9  �8  �7  �6  �5  �4  �3  �2  �1  �0  �/  �.  �-  �,  �+  �*  �)  �(  �'  �&  �%  �$  �#  �"  �!  �   �  ascr  ��ޭ