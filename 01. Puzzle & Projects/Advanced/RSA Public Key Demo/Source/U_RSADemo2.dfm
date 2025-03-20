object Form1: TForm1
  Left = 455
  Top = 201
  AutoScroll = False
  Caption = 'RSA Encryption Demo,  Version 2.1'
  ClientHeight = 791
  ClientWidth = 1017
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 23
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1017
    Height = 768
    ActivePage = IntroSheet
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      object Memo3: TMemo
        Left = 0
        Top = 0
        Width = 1009
        Height = 730
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'This is not the place to learn the theory behind  the RSA Public' +
            ' Key Encryption System, but it may help '
          'understanding to see a  small  example.  The steps are:'
          ''
          '1. Find two different prime numbers, :  p = 61,  q = 53'
          ''
          '2. Calculate the modulus n = p*q: n = 61*53 = 3233'
          ''
          
            '3. Calculate Euler'#39's totient, phi = (p-1)*(q-1): phi = 60*52 = 3' +
            '120'
          ''
          
            '4. Choose public key part, e, less than phi, such that GCD(e,phi' +
            ')=1 (e coprime to phi): e = 17'
          ''
          
            '5. Calculate private key part, d, multiplicative inverse InvMod ' +
            'function) of e relative to phi:     d = e InvMod phi '
          '= 17 Invmod 3120 = 2753  because (17 * 2753) mod 3120 = 1'
          ''
          
            'Public key  = <n, e> = <3233, 17> Private key = <n, d> = <3233, ' +
            '2753>'
          ''
          
            'If P repesents the numerical equivalent of some text, public key' +
            ' (n,e)can be used to calculate C, the encrypted'
          
            'version, from P: C=(P^e mod n), so for example if we use the typ' +
            'ical internal representaion of "A" (decimal 41) '
          
            'then the encrypted version becomes C = 41^17 mod 3233 = 3199 and' +
            ' the decrypting function from the private '
          'key is P=(C^d mod n) P=3199^2753 mod 3233 = 41.  It works!'
          ''
          
            'Whether you are a programmer or not, if you want to try some of ' +
            'these calculations, the Delphiforfun Big'
          
            'Integers test program is available from page http://delphiforfun' +
            '.org/Programs/Library/big_integers.htm.  The'
          
            'test program includes the special functions: next-prime to find ' +
            'large primed to create "n", GCD  to find "e" in '
          
            'step 4, InvMod to calculate "d" in step 5, and ModPow to calcula' +
            'te the encrypted and decrypted values.'
          ''
          
            'In use, if A wants to send a secure message to B, she uses B'#39's p' +
            'ublic key to encrypt her plaintext message '
          
            'and sends the cyphertext (numbers) to B who then uses his privat' +
            'e key to convert the message back to plain '
          'text.'
          ''
          
            'Text is commonly "blocked" with multiple characters encrypted du' +
            'ring each calculation in order to reduce '
          
            'computation time and to make it more difficult to determine the ' +
            'plaintext associated with the encrypted values.  '
          
            'For example, if we want to be able to encrypt all 256 possible "' +
            'characters", including tab, linefeed, carriage '
          
            'return, etc. then there ecrypted text would have 256 possible en' +
            'crypted values, but if we block the characters '
          
            'in groups of 2, there are 256*256 = 65,536 encrypted numbers. Of' +
            ' course, to do this, our modulus ,n, must be '
          'larger than 65,536 since the calculations are performed mod n.'
          ''
          
            'The next page, Signing Messages, contains a brief description of' +
            ' the technique which can verify that the sender '
          
            'is who they say they are, or at least that that they have the pr' +
            'ivate key associated with your corresdpondent'#39's '
          'public key.'
          ''
          
            'The "Alice" and "Bob" pages allow simulated encrypted conversati' +
            'ons between these two. Keys may be up to '
          
            '1024 bits long but be aware that 1024 bit keys may take 30 secon' +
            'ds to calculate.'
          ''
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Signing Messages'
      ImageIndex = 4
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 1009
        Height = 730
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'While the public key encryption presented so far provides a secu' +
            're method for message '
          'exchange, it does not '
          
            'guarantee that the person sending the message is who they say th' +
            'ey are.   However there is a way '
          'that helps'
          'autheticate sender indentity, namely "Message Signing".'
          ''
          
            'If Alice wants to send an authenticated message to Bob, she can ' +
            'encrypt a "signature" using her '
          'private key and '
          
            'then encrypt that encrypted signature a second thime  with Bob'#39's' +
            ' public key and attach it to her '
          'message.  When '
          
            'Bob receives the message, he decrypts as usual with his private ' +
            'key and sees that an encrypted '
          'signature is  '
          
            'attached.  He can decrpyt the signature using Alice'#39's public key' +
            ', if the decrypted text is readable, '
          'he has verified '
          'that the sender is really Alice.'
          ''
          
            'In practice, the signature may be a crypto hash code for the mes' +
            'sage which allows the recipient to '
          'verify that the '
          'message has not been altered during transmission.'
          ''
          
            'I have not added the signing feature to the demo, but it seems t' +
            'hat it could be done without too '
          'much trouble.'
          ''
          '')
        ParentFont = False
        TabOrder = 0
      end
    end
    object AliceSheet: TTabSheet
      Caption = 'Alice'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object Label2: TLabel
        Left = 17
        Top = 215
        Width = 158
        Height = 23
        Caption = 'Message for Bob '
      end
      object Label3: TLabel
        Left = 19
        Top = 20
        Width = 166
        Height = 39
        Caption = 'Alice'#39's Page'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GoBobLbl: TLabel
        Left = 583
        Top = 654
        Width = 265
        Height = 39
        Caption = 'Going to Bob'#39's page '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Comic Sans MS'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object AlicemakeKeyBtn: TButton
        Left = 581
        Top = 442
        Width = 188
        Height = 32
        Caption = 'Make a new key'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = AlicemakeKeyBtnClick
      end
      object AliceRecodeBtn: TButton
        Left = 17
        Top = 435
        Width = 523
        Height = 32
        Caption = 'Encrypt using Bob'#39's public key'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = AliceRecodeBtnClick
      end
      object AliceEncryptedMemo: TMemo
        Left = 17
        Top = 486
        Width = 523
        Height = 175
        Lines.Strings = (
          'Alice'#39's encrypted text shows here')
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object AlicePlainTextMemo: TMemo
        Left = 17
        Top = 245
        Width = 523
        Height = 175
        Lines.Strings = (
          'Hi Bob,'
          ''
          'Long time no see.  Anything exciting happening at your '
          'end?  '
          ''
          'Alice')
        ScrollBars = ssVertical
        TabOrder = 3
        OnKeyDown = MemoKeyDown
      end
      object AliceSendBtn: TButton
        Left = 17
        Top = 670
        Width = 523
        Height = 32
        Caption = 'Send message to Bob'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = AliceSendBtnClick
      end
      object AliceSizeGrp: TRadioGroup
        Left = 584
        Top = 240
        Width = 185
        Height = 191
        Caption = 'Key size'
        ItemIndex = 0
        Items.Strings = (
          '16 bits'
          '64 bits'
          '256 bits'
          '512 bits'
          '1024 bits')
        TabOrder = 5
        OnClick = AlicemakeKeyBtnClick
      end
      object AlicePubKeyMemo: TMemo
        Left = 9
        Top = 82
        Width = 832
        Height = 114
        Lines.Strings = (
          'Alice Public Key')
        ScrollBars = ssVertical
        TabOrder = 6
      end
      object AlicePrivateBtn: TButton
        Left = 573
        Top = 493
        Width = 196
        Height = 60
        Caption = 'Click to see private key'
        TabOrder = 7
        WordWrap = True
        OnClick = PrivateBtnClick
      end
      object AliceClearBtn: TButton
        Left = 815
        Top = 368
        Width = 165
        Height = 101
        Caption = 'Clear and start a new message for Bob'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        WordWrap = True
        OnClick = ClearBtnClick
      end
      object AliceSampleBtn: TButton
        Left = 815
        Top = 248
        Width = 165
        Height = 101
        Caption = 'Reload sample message for Bob'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        WordWrap = True
        OnClick = SampleBtnClick
      end
    end
    object BobSheet: TTabSheet
      Caption = 'Bob'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -22
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      object Label1: TLabel
        Left = 9
        Top = 204
        Width = 180
        Height = 25
        Caption = 'Message for Alice '
      end
      object Label4: TLabel
        Left = 19
        Top = 20
        Width = 150
        Height = 39
        Caption = 'Bob'#39's Page'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GoAliceLbl: TLabel
        Left = 572
        Top = 654
        Width = 280
        Height = 39
        Caption = 'Going to Alice'#39's page '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Comic Sans MS'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object BobMakeKeyBtn: TButton
        Left = 600
        Top = 496
        Width = 185
        Height = 49
        Caption = 'Make a new key'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BobMakeKeyBtnClick
      end
      object BobRecodeBtn: TButton
        Left = 9
        Top = 419
        Width = 528
        Height = 32
        Caption = 'Encrypt using Alice'#39's public key'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BobRecodeBtnClick
      end
      object BobEncryptedmemo: TMemo
        Left = 9
        Top = 470
        Width = 523
        Height = 175
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Alice'#39's encrypted text shows '
          'here')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object BobPlainTextMemo: TMemo
        Left = 9
        Top = 235
        Width = 523
        Height = 165
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Hey kiddo,'
          ''
          'Good to hear from you.  I thought that you '
          'had been permanently lost in the Snows of '
          'Kilimenjaro!'
          ''
          'Not much happening here.  just waiting for '
          'spring to arrive.'
          ''
          'Bob')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
        OnKeyDown = MemoKeyDown
      end
      object BobSendBtn: TButton
        Left = 9
        Top = 662
        Width = 512
        Height = 32
        Caption = 'Send message to Alice'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = BobSendBtnClick
      end
      object BobSizeGrp: TRadioGroup
        Left = 600
        Top = 296
        Width = 185
        Height = 191
        Caption = 'Key size'
        ItemIndex = 0
        Items.Strings = (
          '16 bits'
          '64 bits'
          '256 bits'
          '512 bits'
          '1024 bits')
        TabOrder = 5
        OnClick = BobMakeKeyBtnClick
      end
      object BobPubKeyMemo: TMemo
        Left = 9
        Top = 82
        Width = 816
        Height = 114
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Bob'#39's Public Key')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 6
      end
      object BobPrivateBtn: TButton
        Left = 600
        Top = 565
        Width = 185
        Height = 68
        Caption = 'Click to see private key'
        TabOrder = 7
        WordWrap = True
        OnClick = PrivateBtnClick
      end
      object BobSampleBtn: TButton
        Left = 815
        Top = 304
        Width = 165
        Height = 101
        Caption = 'Reload sample message for Alice'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        WordWrap = True
        OnClick = SampleBtnClick
      end
      object BobClearBtn: TButton
        Left = 815
        Top = 416
        Width = 165
        Height = 101
        Caption = 'Clear and start a new message for Alice'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        WordWrap = True
        OnClick = ClearBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 768
    Width = 1017
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009-2012, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
