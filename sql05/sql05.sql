--1번 가장 늦게 입사한 직원의 이름, 연봉, 근무하는 부서이름
select e.first_name || e.last_name, e.salary, d.department_name
from employees e ,departments d
where e.department_id = d.department_id and e.hire_date in (select max(hire_date)
                                                            from employees);

--2번 평균연봉이 가장 높은 부서 직원들의 직원번호, 이름, 성, 업무, 연봉
select employee_id, first_name, last_name, job_title, salary
from employees e, jobs j, (select department_id, avg(salary) avs
                           from employees
                           group by department_id) a , (select max(avg(salary)) mas
                                                        from employees
                                                        group by department_id) b
where a.avs=b.mas and a.department_id=e.department_id and e.job_id=j.job_id;

--3번 평균 급여가 가장 높은 부서
select d.department_name
from  (select department_id ,avg(salary) avs
       from employees
       group by department_id) a , departments d
where a.avs >= any (select max(avg(salary))
                   from employees
                   group by department_id) and d.department_id=a.department_id;                   

--4번 평균 급여가 가장 높은 지역
select r.region_name
from locations l, countries c, regions r, (select d.location_id, avg(salary) avs --도시별평균연봉
                                           from departments d, employees e
                                           where e.department_id = d.department_id
                                           group by location_id) ee
where ee.location_id=l.location_id and 
      l.country_id=c.country_id and 
      c.region_id=r.region_id
      and ee.avs >= (select max(avg(salary))
                     from employees fe, departments fd
                     where fe.department_id = fd.department_id
                     group by location_id);
                     
--5번 평균 급여가 가장 높은 업무
select job_title
from (select e.job_id, avg(salary) avgs
      from jobs j, employees e
      where j.job_id = e.job_id
      group by e.job_id) a, (select max(avg(salary)) maxs --평균연봉이 가장 큰 업무의 연봉
                             from jobs j, employees e
                             where j.job_id = e.job_id
                             group by e.job_id) b , jobs j
where j.job_id=a.job_id and a.avgs = b.maxs;                             