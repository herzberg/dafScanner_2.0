clc; close all; clear;

types = {'gemara','tosfos','rashi'};
mesechtas = dir('gemaraPics');
mesechtas = mesechtas([mesechtas.isdir]);

for mm = 7:7 %length(mesechtas)
    mesechta = mesechtas(mm).name
for ll = 1:length(types)
    type = types{ll};
statdir = ['../' type '/' mesechta];


files = dir(statdir);
realFiles = files(not([files.isdir]));

realCell= struct2cell(realFiles);
statsFiles = realFiles(not(cellfun('isempty',strfind(realCell(1:5:end),'stats.txt'))));
mydafFiles = realFiles(not(cellfun('isempty',strfind(realCell(1:5:end),'daf.txt'))));

statsCell = struct2cell(statsFiles);


minlinelen = 5; %characters

badgem = [3,2;1,1];
badleft = [1,2;2,2;3,2;1,3;2,3;3,3];
badright = [1,1;2,1;1,2;3,2;2,3;3,3];
logId = fopen( '../logs/statsFixedLogs.txt','a');

for ii = 1:length(mydafFiles)
       pattlen = 3;
       
       name = mydafFiles(ii).name;
       tempind = find(name=='_',1)-1;
       dafnum = str2double(name(1:tempind));
       if isnan(dafnum) %two word name
           tempind = 1:find(name=='_',2)-1;
           tempind = tempnum(2);
           dafnum = str3double(name(1:tempind)); 
       end
       
       
       isamudalef = mod(dafnum,2) == 1;
       try %nan file
           
       tempstats = statsFiles(ii);    
       sname = tempstats.name;
       
       sdafnum = str2double(sname(1:find(sname=='_',1)-1));
       catch
           break
       end
       if dafnum ~= sdafnum
          %do a search for corresponding daf. if not found skip
          searchname = [name(1:tempind) '_stats.txt'];
          tempstats = statsFiles(not(cellfun('isempty',strfind(statsCell(1:5:end),searchname))));
          for nn = 1:length(tempstats)
             if isequal(tempstats(nn).name,searchname)
                 tempstats = tempstats(nn);
                 break;
             end
          end
          if length(tempstats) ~= 1
             continue; 
          end
       end
       
       try
           mydaf = fopen([statdir '/' name],'r');
           stats = fopen([statdir '/' tempstats.name],'r');
       catch
           disp('cont.');
           continue;
       end
       isgoodgood = true;
       currpattern = [];
       currstreak = 0;
       
       numchanges = 0;
       numctschanges = 0;
       numbadlnchanges = 0;
       
       fixedlines = [];
       logline = [];
       
       mline = fgets(mydaf);
       sline = fgets(stats);
       while ischar(mline) && ischar(sline)
           
           ssplit = strsplit(sline,',');
           w = str2double(ssplit(2));
           s = str2double(ssplit(3));
           l = str2double(ssplit(4));
           
           templine = [w,s];
           
           %bad lines problem
           if (isequal(type,'rashi') && isamudalef) || (isequal(type,'tosfos') && ~isamudalef) %on right
              currbad = badright; 
           elseif (isequal(type,'rashi') && ~isamudalef) || (isequal(type,'tosfos') && isamudalef) %on left
              currbad = badleft;
           elseif isequal(type,'gemara')
              currbad = badgem;
           end
           
           testtempline1 = [templine(1)+1,templine(2)];
           testtempline2 = [templine(1),templine(2)-1];
           isoneoff = isequal(testtempline1,currpattern) || isequal(testtempline2,currpattern);
           
           if isequal(type,'tosfos') && dafnum == 31
              yo =342243; 
           end
           
           if sum(ismember(currbad, templine, 'rows')) > 0 
               
               if l == 1
                    mline = fgets(mydaf);
                   sline = fgets(stats);
                   continue;
               end
               
               if ~isempty(currpattern) && currstreak >= pattlen && isoneoff
                   templine = currpattern;
                   numchanges = numchanges + 1;
                   isgoodgood = true;
                   numbadlnchanges = numbadlnchanges + 1;
               else 
                   isgoodgood = false;
                   reason = 'LINE_BAD';
               end
           end
           %end bad lines problem
           
           %cts problem
%            if ~isempty(currpattern) && templine(2) ~= currpattern(2) && sum(templine) ~= sum(currpattern)
%                if (testtempline1(2) == currpattern(2) || sum(testtempline1) == sum(currpattern))
%                        
%                     %templine = testtempline1;
%                     numchanges = numchanges + 1;
%                     numctschanges = numctschanges + 1;
%                     isgoodgood = true;
%                elseif (testtempline2(2) == currpattern(2) || sum(testtempline2) == sum(currpattern))
%                    %templine = testtempline2; 
%                    numchanges = numchanges + 1;
%                     numctschanges = numctschanges + 1;
%                     isgoodgood = true;
%                
%                else 
%                     isgoodgood = false;
%                     reason = 'LINE_NOT_CTS';
%                end
%            end
           %end cts problem
         
           
           if ~isgoodgood
              logline = [ mydafFiles(ii).name ' isbadbad. Failed on line ' int2str(l) '  b/c ' reason];
              break
           end
           
           %pattern
           if isequal(templine,currpattern)
               currstreak = currstreak + 1;
           else 
               currpattern = templine;
               currstreak = 1;
           end
           
           
           fixedlines = [fixedlines; templine];
           
           mline = fgets(mydaf);
           sline = fgets(stats);
       end
       %SECOND PASS OVER DATA
       pattlen = 2;
       skipfirstline = false;
       for jj = 1:size(fixedlines,1)
          templine = fixedlines(jj,:);
          ispattb = false;
          ispatta = false;
          %pattern finding
          if jj >= pattlen+1
              ispattb = true;
              pattb = [];
              for kk = jj-pattlen:jj-1
                  if isempty(pattb)
                      pattb = fixedlines(kk,:);
                  elseif pattb ~= fixedlines(kk,:)
                      ispattb = false;
                      break;
                  end  
              end
              
          end
          if jj <= length(fixedlines)-pattlen-1
              ispatta = true;
              patta = [];
              for kk = jj+1:jj+pattlen+1
                  if isempty(patta)
                      patta = fixedlines(kk,:);
                  elseif patta ~= fixedlines(kk,:)
                      ispatta = false;
                      break;
                  end  
              end
              
          end
          
          if jj == 1 && ispatta && ~isequal(templine,patta) % just skip it, it's probably bad
             skipfirstline = true;
          elseif ispatta && ispattb && ~isequal(templine,patta) && ~isequal(templine,pattb) && isequal(patta,pattb) %if a = c and b ~= a or c but you really want them to be equal, then...
             templine = patta; 
          end
          %end pattern
          
          
          fixedlines(jj,:) = templine;
       end
       if skipfirstline
          fixedlines = fixedlines(2:end,:);
          %add new line numbers
          fixedlines = [fixedlines, (1:size(fixedlines,1))'];
       else
          fixedlines = [fixedlines, (1:size(fixedlines,1))'];
       end
       
       %write
       fileId = fopen([statdir '/' int2str(dafnum) '_statsFixed.txt'],'w');
       fprintf(fileId,[mesechta '_' int2str(dafnum) '.png' ',%d,%d,%d\n'],fixedlines');
       fclose(fileId);
       
       if isamudalef
           amud = 'alef';
       else
           amud = 'bet';
       end
       logline = [type ' - '  mydafFiles(ii).name ' ' amud ' had ' int2str(numchanges) ' change(s). ' int2str(numctschanges) ' CTS. ' int2str(numbadlnchanges) ' BAD_LINE. ' logline '\n'];
       fprintf(logId,logline);
       
       fclose(mydaf);
       fclose(stats);
end
fclose(logId);
end
end
disp('all done!');