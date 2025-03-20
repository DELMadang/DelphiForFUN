object RulesForm: TRulesForm
  Left = 653
  Top = 108
  Width = 604
  Height = 450
  VertScrollBar.Visible = False
  Caption = 'Guidelines'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object rulesMemo: TMemo
    Left = 0
    Top = 0
    Width = 596
    Height = 425
    Align = alTop
    Color = 14024703
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        '1. Define the fields. as illustrated with "Field name"="Field Si' +
        'ze" lines.  Precede'
      
        'a field size with the letter "V" to indicate that it is variable' +
        ' length.  Each'
      
        'variable length field will take up 1 character of the License ke' +
        'ys generated.'
      
        'The sum of sizes + the number of "V" fields must equal the produ' +
        'ct of the specified'
      'key segment size and the number of segments in the key.'
      ''
      
        '2. For each license key to be generated, enter the appropriate "' +
        'Field name"="Field value"'
      
        'lines. As of Version 2.2, only a subset of the fields need be en' +
        'tered and they may'
      
        'be entered in the any order. From previous experiece, I have inc' +
        'luded an "EncryptionVersion"'
      
        'field as the first field.  If modifications to the generation al' +
        'gorithms or fieldsare'
      
        'required in the future, this key would allow the validation code' +
        ' to remain compatible with'
      'all versions.'
      ''
      
        '3. Specify key segment size and number of segments based on fiel' +
        'd definitions. If you'
      
        'calculate thus incorrectly, the program wll display the minimum ' +
        'size. The length of any'
      
        'variable length field may be inceased to meet the segment size x' +
        ' # of segments requirements.'
      ''
      
        '4. Generate an encryption key from a given "seed" value. In a pr' +
        'oduction envirnment,'
      
        'this seed would be embedded in the program that validates the li' +
        'cense, so a constant'
      
        'seed would used when generating license keys.  This would avoid ' +
        'embedding either the'
      'Master key or the Encryption key in the distributed code.'
      ''
      '5. Click the "Make License Key" button to generate a key.'
      ''
      
        '6. The "Back to plain text" button will use the field definition' +
        ' data and the encryption key to'
      'reconvert the License Key'
      'back to the original input data fields.'
      ''
      
        'Note: Special characters, including space characters, in input t' +
        'ext are not supported. See the'
      
        'DFF website for more information about the algorithm and its lim' +
        'itations and potential '
      'enhancements.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
