
class @main
  tree : -> module '$' :
    day   : module 'tutor/forms/drop_down_list' :
      text        : @exports()
      placeholder : 'День'
      selector    : 'first_reg_day'
      default_options     : {
        '0': {value: '1', text: '1'},
        '1': {value: '2', text: '2'},
        '2': {value: '3', text: '3'},
        '3': {value: '4', text: '4'},
        '4': {value: '5', text: '5'},
        '5': {value: '6', text: '6'},
        '6': {value: '7', text: '7'},
        '7': {value: '8', text: '8'},
        '8': {value: '9', text: '9'},
        '9': {value: '10', text: '10'},
        '10': {value: '11', text: '11'},
        '11': {value: '12', text: '12'},
        '12': {value: '13', text: '13'},
        '13': {value: '14', text: '14'},
        '14': {value: '15', text: '15'},
        '15': {value: '16', text: '16'},
        '16': {value: '17', text: '17'},
        '17': {value: '18', text: '18'},
        '18': {value: '19', text: '19'},
        '19': {value: '20', text: '20'},
        '20': {value: '21', text: '21'},
        '21': {value: '22', text: '22'},
        '22': {value: '23', text: '23'},
        '23': {value: '24', text: '24'},
        '24': {value: '25', text: '25'},
        '25': {value: '26', text: '26'},
        '26': {value: '27', text: '27'},
        '27': {value: '28', text: '28'},
        '28': {value: '29', text: '29'},
        '29': {value: '30', text: '30'},
        '30': {value: '31', text: '31'}
      }
      value : @exports 'day_value'
    month : module 'tutor/forms/drop_down_list' :
      placeholder : 'Месяц'
      selector    : 'first_reg_month'
      default_options     : {
        '0': {value: 'january', text: 'январь'},
        '1': {value: 'february', text: 'февраль'},
        '2': {value: 'march', text: 'март'},
        '3': {value: 'april', text: 'апрель'},
        '4': {value: 'may', text: 'май'},
        '5': {value: 'june', text: 'июнь'},
        '6': {value: 'july', text: 'июль'},
        '7': {value: 'august', text: 'август'},
        '8': {value: 'september', text: 'сентябрь'},
        '9': {value: 'october', text: 'октябрь'},
        '10': {value: 'november', text: 'ноябрь'},
        '11': {value: 'december', text: 'декабрь'}
      }
      value: @exports 'month_value'
    year  : module 'tutor/forms/drop_down_list' :
      placeholder : 'Год'
      selector    : 'first_reg_month'
      default_options     : {
        '0': {value: '1', text: '1997'},
        '1': {value: '2', text: '1996'},
        '2': {value: '3', text: '1995'},
        '3': {value: '4', text: '1994'},
        '4': {value: '5', text: '1993'},
        '5': {value: '6', text: '1992'},
        '6': {value: '7', text: '1991'},
        '7': {value: '8', text: '1990'},
        '8': {value: '9', text: '1989'},
        '9': {value: '10', text: '1988'},
        '10': {value: '11', text: '1987'},
        '11': {value: '12', text: '1986'},
        '12': {value: '13', text: '1985'},
        '13': {value: '14', text: '1984'},
        '14': {value: '15', text: '1983'},
        '15': {value: '16', text: '1982'},
        '16': {value: '17', text: '1981'},
        '17': {value: '18', text: '1980'},
        '18': {value: '19', text: '1979'},
        '19': {value: '20', text: '1978'},
        '20': {value: '21', text: '1977'},
        '21': {value: '22', text: '1976'},
        '22': {value: '23', text: '1875'},
        '23': {value: '24', text: '1974'},
        '24': {value: '25', text: '1973'},
        '25': {value: '26', text: '1972'},
        '26': {value: '27', text: '1971'},
        '27': {value: '28', text: '1970'},
        '28': {value: '29', text: '1969'},
        '29': {value: '30', text: '1968'},
        '30': {value: '31', text: '1967'},
        '31': {value: '32', text: '1966'},
        '32': {value: '33', text: '1965'},
        '33': {value: '34', text: '1964'},
        '34': {value: '35', text: '1963'},
        '35': {value: '36', text: '1962'},
        '36': {value: '37', text: '1961'},
        '37': {value: '38', text: '1960'},
        '38': {value: '39', text: '1959'},
        '39': {value: '40', text: '1958'},
        '40': {value: '41', text: '1957'},
        '41': {value: '42', text: '1956'},
        '42': {value: '43', text: '1955'},
        '43': {value: '44', text: '1954'},
        '44': {value: '45', text: '1953'},
        '45': {value: '46', text: '1952'},
        '46': {value: '47', text: '1951'},
        '47': {value: '48', text: '1950'},
        '48': {value: '49', text: '1949'},
        '49': {value: '50', text: '1948'},
        '50': {value: '51', text: '1947'},
        '51': {value: '52', text: '1946'},
        '52': {value: '53', text: '1945'},
        '53': {value: '54', text: '1944'},
        '54': {value: '55', text: '1943'},
        '55': {value: '56', text: '1942'},
        '56': {value: '57', text: '1941'},
        '57': {value: '58', text: '1940'},
        '58': {value: '59', text: '1939'},
        '59': {value: '60', text: '1938'},
        '60': {value: '61', text: '1937'},
        '61': {value: '62', text: '1936'},
        '62': {value: '63', text: '1935'},
        '63': {value: '64', text: '1934'},
        '64': {value: '65', text: '1933'},
        '65': {value: '66', text: '1932'},
        '66': {value: '67', text: '1931'},
        '67': {value: '68', text: '1930'},
        '68': {value: '69', text: '1929'},
        '69': {value: '70', text: '1928'},
        '70': {value: '71', text: '1927'},
        '71': {value: '72', text: '1926'},
        '72': {value: '73', text: '1925'},
        '73': {value: '74', text: '1924'},
        '74': {value: '75', text: '1923'},
        '75': {value: '76', text: '1922'},
        '76': {value: '77', text: '1921'},
        '77': {value: '78', text: '1920'},
        '78': {value: '79', text: '1919'},
        '79': {value: '80', text: '1918'},
        '80': {value: '81', text: '1917'},
        '81': {value: '82', text: '1916'}
      }
      value: @exports 'year_value'


